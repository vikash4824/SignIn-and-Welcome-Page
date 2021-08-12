//
//  DetailsViewController.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDes: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dicData = NSManagedObject()
    
    var arrName = NSMutableArray()
    
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 10.0,
                                     bottom: 10.0,
                                     right: 10.0)
    let itemsPerRow: CGFloat = 3
    
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        _flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        
        _flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 0.0
        _flowLayout.minimumLineSpacing = 10.0
        return _flowLayout
    }
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout = flowLayout
        
        let data = dicData.value(forKey: "photo") as! NSData

        let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
        let arrayObject = unarchiveObject as? NSMutableArray
        arrName = arrayObject!

        lblTitle.text = dicData.value(forKey: "title") as? String
        lblDes.text = dicData.value(forKey: "descriptions") as? String

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Actioh Method
    @IBAction func CLICKEDBACK(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICollectionView Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let dicData = arrName[indexPath.row] as? UIImage
        
        cell.imgPhoto.image = dicData
        
        cell.imgPhoto.layer.cornerRadius = 5
        cell.imgPhoto.clipsToBounds = true
        
        return cell
    }
    
    
}
