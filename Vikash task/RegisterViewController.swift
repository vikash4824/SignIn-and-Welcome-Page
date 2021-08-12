//
//  RegisterViewController.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmai: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtName.delegate = self
        txtMobile.delegate = self
        txtEmai.delegate = self
        txtPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK:- validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,15}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: password)
        if(isMatched  == true) {
            return true
        }  else {
            return false
        }
    }
    
    func isValidInputName(Input:String) -> Bool
    {
        let RegEx = "\\A\\w{4,25}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
   
    
    //MARK:- Action Method
    @IBAction func clickedSignup(_ sender: Any)
    {
        if txtName.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Name", cancelButtonTitle: "OK")
        }
        else if !(txtName.text!.count > 3)
        {
            AppUtilites.showAlert(title: "", message: "Please valid Name", cancelButtonTitle: "OK")
        }
        else if !(txtName.text!.count < 24)
        {
            AppUtilites.showAlert(title: "", message: "Please valid Name", cancelButtonTitle: "OK")
        }
        else if txtMobile.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Mobile Number", cancelButtonTitle: "OK")
        }
        else if txtMobile.text!.count != 10
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Mobile Number", cancelButtonTitle: "OK")
        }
        else if txtEmai.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Email Address", cancelButtonTitle: "OK")
        }
        else if !isValidEmail(testStr: txtEmai.text!)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Email Address", cancelButtonTitle: "OK")
        }
        else if txtPassword.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Password", cancelButtonTitle: "OK")
        }
        else if !isPasswordValid(txtPassword.text!)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Password", cancelButtonTitle: "OK")
        }
        else
        {
            let _:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as NSManagedObject
            newUser.setValue(txtEmai.text, forKey: "email")
            newUser.setValue(txtMobile.text, forKey: "mobile")
            newUser.setValue(txtName.text, forKey: "name")
            newUser.setValue(txtPassword.text, forKey: "password")
            do {
                try context.save()
            } catch {}
            print(newUser)
            print("Registered  Sucessfully")
            
            UserDefaults.standard.setValue(true, forKey: "UserLogin")
            UserDefaults.standard.synchronize()
            
            AppUtilites.showAlert(title: "", message: "Registered  Sucessfully", actionButtonTitle: "OK") {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let home = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let homeNavigation = UINavigationController(rootViewController: home)
                homeNavigation.navigationController?.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = homeNavigation
                appDelegate.window?.makeKeyAndVisible()
            }
            
        }
    }
    
    
    @IBAction func clickedSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtName {
            txtMobile.becomeFirstResponder()
            return false
        } else if textField == txtMobile {
            txtEmai.becomeFirstResponder()
            return false
        } else if textField == txtEmai {
            txtPassword.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
   
}
