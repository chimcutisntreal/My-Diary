//
//  ViewController.swift
//  DiaryTest3
//
//  Created by Chinh on 10/8/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit
import CoreData
import FSCalendar

class HomeViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FSCalendarDelegate, FSCalendarDataSource{
    
    var dataList: [NSManagedObject] = []
    var dataModel: DiaryData!
    var imageName = ""
    var fontName = ""
    var fontColor : UIColor!
    
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var lblRecent: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataModel = DiaryData()
        dataList = dataModel.showAllData()
        self.tableView.reloadData()
        
        
        //Set background
        background?.image = UIImage(named: imageName)
        
        //RETRIEVE USER'S BACKGROUND
        saveUserBackground(backgroundImage: background)
        let data = UserDefaults.standard.object(forKey: "pickedImage") as? NSData
        if let imageData = data {
            let picture = UIImage(data: imageData as Data)
            background?.image = picture
        }
        //RETRIEVE USER'S FONT
        fontName = UserDefaults.standard.string(forKey: "fontname") ?? ""
        
        //Set font
        UITextField.appearance().font = UIFont(name: fontName, size: 20)
        UITextView.appearance().font = UIFont(name: fontName, size: 17)
        
        //RETRIEVE USER'S FONT COLOR
        fontColor = UserDefaults.standard.color(forKey: "fontcolor")
        
        //SET COLOR OF FONT
        UITextField.appearance().textColor = fontColor
        UITextView.appearance().textColor = fontColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.refreshControl = refresher
        lblRecent.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        
        //Add slide menu button
        self.addSlideMenuButton()
    }
    
    @IBAction func pressOnAdd(_ sender: Any) {
        let gotoAdd = storyboard?.instantiateViewController(withIdentifier: "AddVC")
        self.navigationController?.pushViewController(gotoAdd!, animated: true)
    }
    @IBAction func gotoListAudio(_ sender: Any){
        let gotoListAudio = storyboard?.instantiateViewController(withIdentifier: "listAudioVC")
        self.navigationController?.pushViewController(gotoListAudio!, animated: true)
    }
    
    
    // TABLE VIEW CELL
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for:indexPath) as! CustomTableViewCell
        let entityName = dataList[indexPath.row]
        cell.lblTitle?.text = entityName.value(forKey: "diaryTitle") as? String
        cell.lblBodyText?.text = entityName.value(forKey: "diaryBodyText") as? String
        if let createdAt = entityName.value(forKey: "diaryDateTime") as?  String {
            cell.lblcreatedAt?.text = "\(createdAt)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let obj = dataList[indexPath.row]
            let deleteObj = dataModel.deleteObject(obj: obj)
            if (deleteObj) {
                dataList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
        let entityName = dataList[indexPath.row]
        vc.passTitle = (entityName.value(forKey: "diaryTitle") as? String)!
        vc.passBodyText = (entityName.value(forKey: "diaryBodyText") as? String)!
        if let passImageData = (entityName.value(forKey: "diaryImage") as? Data) {
            vc.passImage = UIImage(data: passImageData)
        }
        vc.passDate = (entityName.value(forKey: "diaryDateTime") as? String)!
        vc.isEditView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let diaryList = storyboard?.instantiateViewController(withIdentifier: "GotoListDiary") as! DiaryListViewController
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let now = df.string(from:date)
        diaryList.title = now
        diaryList.selectedDate = now
        
        self.navigationController?.pushViewController(diaryList, animated: true)
    }
    
    //SEGUE TO COPY BACKGROUND
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GotoListDiary" {
            let itemToCopy = segue.destination as! DiaryListViewController
            itemToCopy.passBackground = background
        }
        if segue.identifier == "AddVC" {
            let itemToCopy = segue.destination as! AddViewController
            itemToCopy.passBackground = background
        }
        
    }
    //PULL TO REFRESH
    @objc lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    @objc
    func requestData() {
        self.tableView.reloadData()
        let deadline = DispatchTime.now() + .microseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    //SEARCH BAR
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
            fetchRequest.predicate = NSPredicate(format: "diaryTitle contains[c] '\(searchText)' ")
            do {
                dataList = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch {
                print("Could not get search-data")
            }
        }
        else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else {
                    return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
            
            do {
                dataList = try managedContext.fetch(fetchRequest)
            } catch {
                print("Could not get data")
            }
            
        }
        self.tableView?.reloadData()
    }
    //USER DEFAULTS
    
    func saveFontName(fontname: String){
        UserDefaults.standard.set(fontname, forKey: "fontname")
    }
    
    func saveFontColor(fontcolor: UIColor) {
        UserDefaults.standard.setColor(fontcolor, forKey: "fontcolor")
    }
    
    
}
// EXTEND TO PICK UICOLOR - FONTCOLOR
extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(_ value: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = value {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    
}
extension UIViewController {
    
    func saveUserBackground(backgroundImage: UIImageView?) {
        if let pickedImage = backgroundImage?.image {
            let imageData = pickedImage.pngData()
            UserDefaults.standard.set(imageData, forKey: "pickedImage")
        }
    }
}

