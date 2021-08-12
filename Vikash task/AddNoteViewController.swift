//
//  AddNoteViewController.swift
//  Vikash task
//
//  Created by Vikash on 11/08/21.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ImagePickerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDes: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagePicker: ImagePicker!
    
    
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
    
    //MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.delegate = self
        txtDes.delegate = self
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        txtDes.placeholder = "Enter Description"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout = flowLayout
        
        txtTitle.setLeftPaddingPoints(5)
        txtTitle.setRightPaddingPoints(5)
        
        txtTitle.layer.cornerRadius = 8
        txtTitle.clipsToBounds = true
        txtTitle.layer.borderWidth = 1
        txtTitle.layer.borderColor = UIColor.lightGray.cgColor
        
        txtDes.layer.cornerRadius = 8
        txtDes.clipsToBounds = true
        txtDes.layer.borderWidth = 1
        txtDes.layer.borderColor = UIColor.lightGray.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtTitle {
            txtDes.becomeFirstResponder()
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
    @IBAction func clickedSubmit(_ sender: Any)
    {
        if txtTitle.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Title", cancelButtonTitle: "OK")
        }
        else if !(txtTitle.text!.count > 4)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Title", cancelButtonTitle: "OK")
        }
        else if !(txtTitle.text!.count < 99)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Title", cancelButtonTitle: "OK")
        }
        else if txtDes.text == ""
        {
            AppUtilites.showAlert(title: "", message: "Please enter Description", cancelButtonTitle: "OK")
        }
        else if !(txtDes.text!.count > 100)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Description", cancelButtonTitle: "OK")
        }
        else if !(txtDes.text!.count < 1000)
        {
            AppUtilites.showAlert(title: "", message: "Please enter valid Description", cancelButtonTitle: "OK")
        }
        else if arrName.count == 0
        {
            AppUtilites.showAlert(title: "", message: "Please select Photo", cancelButtonTitle: "OK")
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "AllNotes", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(txtTitle.text, forKey: "title")
            newUser.setValue(txtDes.text, forKey: "descriptions")
            
            let data = NSKeyedArchiver.archivedData(withRootObject: arrName)
            newUser.setValue(data, forKey: "photo")
            
            do {
                
                try context.save()
                
                let alert = UIAlertController(title:"Alert", message: "Data Added", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { (alert) in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } catch {
                
                print("Failed saving")
            }
        }
    }
    @IBAction func clickedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedAddPhoto(_ sender: UIButton) {
        
        if self.arrName.count < 11
        {
            self.imagePicker.present(from: sender)
        }
        else
        {
            AppUtilites.showAlert(title: "", message: "You can select only max. 10 Photos", cancelButtonTitle: "OK")
        }
    }
    
    
    func isValidInputDes(Input:String) -> Bool
    {
        let RegEx = " \\A\\w{100,1000}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
   
    func didSelect(image: UIImage?) {
        
        self.arrName.add(image!)
        self.collectionView.reloadData()
    }
    
    //MARK:- UICollectionView
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


//MARK:- UICollectionView
extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

//MARK:- UIImagePickerController

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
