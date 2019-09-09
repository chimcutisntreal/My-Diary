//
//  AddViewController.swift
//  DiaryTest3
//
//  Created by Chinh on 11/10/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var dataList: [NSManagedObject] = []
    var dataModel: DiaryData!
    var passBackGroundName = ""
    var passTitle = ""
    var passBodyText = ""
    var passDate = ""
    var passImage : UIImage!
    var isEditView = false
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var passBackground: UIImageView!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillLayoutSubviews() {
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.cornerRadius = 15
        
        txtTitle.layer.borderWidth = 1.5
        txtTitle.layer.borderColor = UIColor.white.cgColor
        txtTitle.layer.cornerRadius = 15
        
        //SET CORNER RADIUS
        self.imageView?.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView?.layer.masksToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataModel = DiaryData()
        if isEditView == true {
            txtTitle?.text = passTitle
            textView?.text = passBodyText
            imageView?.image = passImage
            txtDate?.text = passDate
        }
        view.backgroundColor = UIColor(red: 147/255, green: 185/255, blue: 230/255, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.text = "Write your diary"
        print(isEditView)
        passBackground?.image = UIImage(named: passBackGroundName)
        saveUserBackground(backgroundImage: passBackground)
        let data = UserDefaults.standard.object(forKey: "pickedImage") as? NSData
        if let imageData = data {
            let picture = UIImage(data: imageData as Data)
            passBackground?.image = picture
        }
        
        //SET CAMERA BUTTON TO THE RIGHT OF TEXTFIELD
        let btnCamera = UIButton(type: .custom)
        btnCamera.setImage(UIImage(named: "camera1"), for: .normal)
        btnCamera.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btnCamera.frame = CGRect(x: 0, y: 0, width: CGFloat(33), height: CGFloat(25))
        btnCamera.addTarget(self, action: #selector(self.btnChooseImageSource(_:)), for: .touchUpInside)
        txtTitle?.rightView = btnCamera
        txtTitle?.rightViewMode = .always
        
        //Display current date in textfield
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let currentDate = formatter.string(from: date)
        txtDate.text = currentDate
        txtDate.isUserInteractionEnabled = false
    }
    
    
    @IBAction func pressOnSave(_ sender: Any) {
        if isEditView == true {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm dd/MM/yyyy"
            let currentDate = formatter.string(from: date)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
            fetchRequest.predicate = NSPredicate(format: "diaryTitle = %@",passTitle)
            fetchRequest.returnsObjectsAsFaults = false
            let imageData = chosenImage?.pngData()
            do {
                let result = try managedContext.fetch(fetchRequest)
                result[0].setValue(txtTitle.text, forKey: "diaryTitle")
                result[0].setValue(textView.text, forKey: "diaryBodyText")
                result[0].setValue(currentDate,forKey: "diaryDateTime")
                result[0].setValue(imageData, forKey: "diaryImage")
                result[0].setValue(txtDate.text, forKey: "diaryDateTime")
            } catch {
                print("update error")
            }
            do {
                try managedContext.save()
            } catch {
                print("update error")
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            if(txtTitle.text?.isEmpty)!{
                // ALERT
                let alert = UIAlertController(title: "Please Enter Title", message: "", preferredStyle: .alert)
                let OK = UIAlertAction(title: "Got it!!!", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let imageData = chosenImage?.pngData()
                self.dataModel.save(inputTitle: txtTitle.text!, inputBodyText: textView.text!, createdAt:txtDate.text!, inputImage: imageData)
            }
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @IBAction func pressOnEdit(_ sender: Any) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: "Select date", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        let done = UIAlertAction(title: "Done", style: .cancel) { (action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            self.txtDate.text = dateFormatter.string(from: datePicker.date)
            print(dateString)
        }
        
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    // TEXTVIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your diary" {
            textView.text = nil
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your diary"
            textView.textColor = UIColor.darkGray
        }
    }
    // IMAGE PICKER
    var chosenImage : UIImage?
    var alertController : UIAlertController?
    var pickerController : UIImagePickerController?
    
    
    
    @IBAction func btnChooseImageSource(_ sender: UIButton) {
        alertController = UIAlertController(title: "Take image", message: "Choose image source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("You choose Camera")
            self.openCamera()
        }
        let photoAction = UIAlertAction(title: "Your photos", style: .default) { (action) in
            print("You choose Photo")
            self.openPhoto()
        }
        alertController?.addAction(cameraAction)
        alertController?.addAction(photoAction)
        alertController?.view.tintColor = UIColor.magenta
        self.present(alertController!, animated: true) {
            print("presented")
        }
    }
    
    func openCamera() {
        pickerController = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
            return
        }
        pickerController?.delegate = self
        pickerController!.allowsEditing = true
        pickerController?.sourceType = .camera
        self.present(pickerController!, animated: true) {
            print("presented Camera")
        }
    }
    
    func openPhoto() {
        pickerController = UIImagePickerController()
        pickerController?.delegate = self
        pickerController?.allowsEditing = true
        pickerController?.sourceType = .photoLibrary;
        self.present(pickerController!, animated: true, completion: nil)
    }
    
    //UINavigationControllerDelegate
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        self.chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.imageView?.image = self.chosenImage
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    
}
