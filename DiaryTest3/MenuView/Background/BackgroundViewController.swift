//
//  BackgroundViewController.swift
//  DiaryTest3
//
//  Created by Chinh on 10/19/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var tapCamera: UIBarButtonItem!
    
    let items = ["1","2","3","4","5","6","7","8","9","10",
                 "11","12","13","14","15","16","17","18","19","20",
                 "21","22","23","24","25","26","27","28","29","30"]
    let backgroundImage: [UIImage] = [
        UIImage(named: "1")!,UIImage(named: "2")!,UIImage(named: "3")!,
        UIImage(named: "4")!,UIImage(named: "5")!,UIImage(named: "6")!,
        UIImage(named: "7")!,UIImage(named: "8")!,UIImage(named: "9")!,
        UIImage(named: "10")!,UIImage(named: "11")!,UIImage(named: "12")!,
        UIImage(named: "13")!,UIImage(named: "14")!,UIImage(named: "15")!,
        UIImage(named: "16")!,UIImage(named: "17")!,UIImage(named: "18")!,
        UIImage(named: "19")!,UIImage(named: "20")!,UIImage(named: "21")!,
        UIImage(named: "22")!,UIImage(named: "23")!,UIImage(named: "24")!,
        UIImage(named: "25")!,UIImage(named: "26")!,UIImage(named: "27")!,
        UIImage(named: "28")!,UIImage(named: "29")!,UIImage(named: "30")!
    ]
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionViewCell
        cell.itemView.image = backgroundImage[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 60 ) / 2, height:(collectionView.frame.size.width - 60 ) / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //HOME VC
        let HomeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        HomeVC.imageName = items[indexPath.row]
        print(HomeVC.imageName)
        self.navigationController?.pushViewController(HomeVC, animated: true)
        //DIARYLIST VC
        let diaryList = storyboard?.instantiateViewController(withIdentifier: "GotoListDiary") as! DiaryListViewController
        diaryList.passImageName = items[indexPath.row]
        //VIEWSCENCE VC
        let viewScence = storyboard?.instantiateViewController(withIdentifier: "GotoListDiary") as! DiaryListViewController
        viewScence.passImageName = items[indexPath.row]
        //ADD VC
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
        addVC.passBackGroundName = items[indexPath.row]
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

