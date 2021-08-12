//
//  AppDelegate.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let userLogin = UserDefaults.standard.value(forKey: "UserLogin") as? Bool
        {
            if userLogin == true
            {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let home = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let homeNavigation = UINavigationController(rootViewController: home)
                homeNavigation.navigationController?.navigationBar.isHidden = true
                self.window?.rootViewController = homeNavigation
                self.window?.makeKeyAndVisible()
            }
            else
            {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let home = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let homeNavigation = UINavigationController(rootViewController: home)
                homeNavigation.navigationController?.navigationBar.isHidden = true
                self.window?.rootViewController = homeNavigation
                self.window?.makeKeyAndVisible()
            }
        }
       
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Vikash")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

