//
//  ViewController.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
//        txtEmail.text = "test@gmail.com"
//        txtPassword.text = "Admin@123"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Action Method
    @IBAction func clickedLogin(_ sender: Any)
    {
        if txtEmail.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Mobile or Email", cancelButtonTitle: "OK")
        }
        else if txtPassword.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Password", cancelButtonTitle: "OK")
        }
        else
        {
          
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                 let searchString = self.txtEmail.text
                 let searcghstring2 = self.txtPassword.text
                 request.predicate = NSPredicate (format: "email == %@", searchString!)
                 do
                 {
                     let result = try context.fetch(request)
                     if result.count > 0
                     {
                         let n = (result[0] as AnyObject).value(forKey: "email") as! String
                         let p = (result[0] as AnyObject).value(forKey: "password") as! String

                         if (searchString == n && searcghstring2 == p)
                         {

                            UserDefaults.standard.setValue(true, forKey: "UserLogin")
                            UserDefaults.standard.synchronize()
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let home = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            let homeNavigation = UINavigationController(rootViewController: home)
                            homeNavigation.navigationController?.navigationBar.isHidden = true
                            appDelegate.window?.rootViewController = homeNavigation
                            appDelegate.window?.makeKeyAndVisible()
                         }
                         else if (searchString == n || searcghstring2 == p)
                         {
                              print("password incorrect")
                            AppUtilites.showAlert(title: "no user found ", message: "password incorrect", cancelButtonTitle: "OK")
                         }
                     }
                     else
                     {
                        AppUtilites.showAlert(title: "no user found ", message: "invalid username ", cancelButtonTitle: "OK")
                         print("no user found")
                     }
                 }
                 catch
                 {
                     print("error")
                 }
             }
          
                      
    }
    
    @IBAction func clickedSignUp(_ sender: Any)
    {
        
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
