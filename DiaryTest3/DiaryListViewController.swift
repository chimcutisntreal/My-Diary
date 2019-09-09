//
//  DiaryListVewController.swift
//  DiaryTest3
//
//  Created by Chinh on 10/14/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit
import CoreData
class DiaryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataList: [NSManagedObject] = []
    var dataModel: DiaryData!
    var selectedDate = ""
    var passImageName = ""
    
    @IBOutlet weak var passBackground: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataModel = DiaryData()
        dataList = dataModel.showDataByDate(selectedDate: selectedDate)
        self.tableView?.reloadData()
        view.backgroundColor = UIColor(red: 147/255, green: 185/255, blue: 230/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.refreshControl = refresher
        passBackground?.image = UIImage(named: passImageName)
        print(passImageName)
        saveUserBackground(backgroundImage: passBackground)
        let data = UserDefaults.standard.object(forKey: "pickedImage") as? NSData
        if let imageData = data {
            let picture = UIImage(data: imageData as Data)
            passBackground?.image = picture
        }
//        let AddVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as! ViewController
//        AddVC.getSelectedDate = title!
//        print("A", title)
//        print("A1", AddVC.getSelectedDate)
  
      
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
        let deadline = DispatchTime.now() + .microseconds(1500)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for:indexPath) as! CustomTableViewCell
        let entityName = dataList[indexPath.row]
        cell.lblTitle?.text = entityName.value(forKey: "diaryTitle") as? String
        cell.lblBodyText?.text = entityName.value(forKey: "diaryBodyText") as? String
        if let createdAt = entityName.value(forKey: "diaryDateTime") as?  String {
            cell.lblcreatedAt?.text = ""
        }
//        if let imageViewCellData = (entityName.value(forKey: "diaryImage") as? Data) {
//            cell.imageViewCell?.image = UIImage(data: imageViewCellData)
//        }
        return cell
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let obj = dataList[indexPath.row]
            let deleteObj = dataModel.deleteObject(obj: obj)
            if (deleteObj) {
                dataList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
        }
        self.tableView?.reloadData()
    }
}
