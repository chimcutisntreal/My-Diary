//
//  FontViewController.swift
//  DiaryTest3
//
//  Created by Chinh on 10/19/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit
import Pastel

class FontViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var tableView : UITableView?
    let items = ["MarkerFelt-Thin","BradleyHandITCTT-bold","TamilSangamMN",
                 "ChalkboardSE-Regular","Futura-medium","ArialHebrew-light",
                 "AmericanTypewriter-bold","Rockwell-Regular","Chalkduster",
                 "Menlo-Regular","AvenirNext-Regular"]

    let fontItems: [UIFont] = [
        UIFont(name: "MarkerFelt-Thin", size: 18.0)!,
        UIFont(name: "BradleyHandITCTT-bold",size: 18.0)!,
        UIFont(name: "TamilSangamMN",size: 18.0)!,
        UIFont(name: "ChalkboardSE-Regular",size: 18.0)!,
        UIFont(name: "Futura-medium",size: 18.0)!,
        UIFont(name: "ArialHebrew-light",size: 18.0)!,
        UIFont(name: "AmericanTypewriter-bold",size: 18.0)!,
        UIFont(name: "Rockwell-Regular",size: 18.0)!,
        UIFont(name: "Chalkduster",size: 18.0)!,
        UIFont(name: "Menlo-Regular",size: 18.0)!,
        UIFont(name: "AvenirNext-Regular",size: 18.0)!
      
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradient()
        tableView?.reloadData()
                // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FontTableViewCell
        cell.textLabel?.font = fontItems[indexPath.row]
        cell.textLabel?.text = "Your font will look like this"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let HomeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        HomeVC.fontName = items[indexPath.row]
        print(HomeVC.fontName)
        HomeVC.saveFontName(fontname: HomeVC.fontName)
        self.navigationController?.pushViewController(HomeVC, animated: true)
        
        
    }
//COLLECTION VIEW - FONT COLOR

    let colors : [UIColor] = [
        UIColor(red: 46/255, green: 81/255, blue: 221/255, alpha: 1),
        UIColor(red: 124/255, green: 123/255, blue: 124/255, alpha: 1),
        UIColor(red: 29/255, green: 66/255, blue: 15/255, alpha: 1),
        UIColor(red: 13/255, green: 40/255, blue: 4/255, alpha: 1),
        UIColor(red: 99/255, green: 163/255, blue: 116/255, alpha: 1),
        UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        UIColor(red: 252/255, green: 255/255, blue: 253/255, alpha: 1),
        UIColor(red: 29/255, green: 170/255, blue: 144/255, alpha: 1),
        UIColor(red: 10/255, green: 209/255, blue: 172/255, alpha: 1),
        UIColor(red: 5/255, green: 63/255, blue: 52/255, alpha: 1),
        UIColor(red: 183/255, green: 1/255, blue: 1/255, alpha: 1),
        UIColor(red: 5/255, green: 106/255, blue: 142/255, alpha: 1),
        UIColor(red: 4/255, green: 30/255, blue: 94/255, alpha: 1),
        UIColor(red: 237/255, green: 140/255, blue: 14/255, alpha: 1),
        UIColor(red: 237/255, green: 181/255, blue: 14/255, alpha: 1),
        UIColor(red: 103/255, green: 14/255, blue: 237/255, alpha: 1),
        UIColor(red: 242/255, green: 174/255, blue: 232/255, alpha: 1),
        UIColor(red: 61/255, green: 4/255, blue: 91/255, alpha: 1),
        UIColor(red: 188/255, green: 71/255, blue: 182/255, alpha: 1),
        UIColor(red: 191/255, green: 13/255, blue: 1414/255, alpha: 1)
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let HomeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        HomeVC.fontColor = colors[indexPath.row]
        HomeVC.saveFontColor(fontcolor: HomeVC.fontColor)
        print(HomeVC.fontColor)
        self.navigationController?.pushViewController(HomeVC, animated: true)
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}



