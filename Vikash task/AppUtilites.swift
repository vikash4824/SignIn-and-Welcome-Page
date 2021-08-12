//
//  AppUtilites.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import Foundation

class AppUtilites: NSObject {
    
    class var sharedInstance: AppUtilites {
        struct Static {
            static let instance: AppUtilites = AppUtilites()
        }
        return Static.instance
    }
    
    
    // MARK: - AlertView
    
    class func showAlert(title: String, message: String, cancelButtonTitle: String) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: cancelButtonTitle, style: .default))
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
    class func showAlert(title: String, message: String, actionButtonTitle: String, completionHandler : @escaping () -> Void) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
    class func showAlert(title: String, message: String, actionButtonTitle: String, cancelButtonTitle: String, completionHandler : @escaping () -> Void) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        
        alertView.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
}


public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
