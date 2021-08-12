//
//  HomeViewController.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- IBOutlet
    @IBOutlet weak var tblView: UITableView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var myStringValue : String?

    var arrData = NSMutableArray()
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getdata()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Action Method
    @IBAction func clickedAddNote(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickedLout(_ sender: Any)
    {
        
        AppUtilites.showAlert(title: "", message: "Are you sure want to Logout?", actionButtonTitle: "Yes", cancelButtonTitle: "No") {
            UserDefaults.standard.setValue(false, forKey: "UserLogin")
            UserDefaults.standard.synchronize()

            let appDelegate :AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let homeNavigation = UINavigationController(rootViewController: home)
            homeNavigation.navigationController?.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = homeNavigation
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    //MARK:- UITableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        let dic = arrData[indexPath.row] as! NSManagedObject
        
        cell.lblTitle.text = dic.value(forKey: "title") as? String
        cell.lblDes.text = dic.value(forKey: "descriptions") as? String
        
        let data = dic.value(forKey: "photo") as! NSData

        let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
        let arrayObject = unarchiveObject as? NSMutableArray
        
        let dicData = arrayObject?[0] as? UIImage
        
        cell.imgHome.image = dicData
        cell.imgHome.layer.cornerRadius = 5
        cell.imgHome.clipsToBounds = true
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        let dic = arrData[indexPath.row] as! NSManagedObject
        vc.dicData = dic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
  
    //MARK:- Get Data
    func getdata()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AllNotes")
        
        arrData.removeAllObjects()
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                arrData.add(data)
            }
            
            if  self.arrData.count > 0
            {
                
            }
            else
            {
                
            }
            
        } catch {
            
            
            print("Failed")
        }
        
        tblView.reloadData()
    }
}
