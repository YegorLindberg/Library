//
//  AddingBookController.swift
//  Corporative Library
//
//  Created by Moore on 08.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

extension AddingBookVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    func HideKeyboard() {
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}

class AddingBookVC: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleAdd: UITextField!
    @IBOutlet weak var yearAdd: UITextField!
    @IBOutlet weak var linkAdd: UITextField!
    @IBOutlet weak var descriptionAdd: UITextField!
    @IBOutlet weak var authorsAdd: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAdd.delegate = self
        yearAdd.delegate = self
        linkAdd.delegate = self
        descriptionAdd.delegate = self
        authorsAdd.delegate = self
        
        self.HideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view.
    }

    
    func textFieldShouldeturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func Keyboard(notification: Notification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    
    @IBAction func AddingTapped(_ sender: UIButton) {
        let newTitle = titleAdd.text!
        let newLink = linkAdd.text!
        let newAuthors = authorsAdd.text!
        let newDescription = descriptionAdd.text!
        let newYear = yearAdd.text!
        AddingBook(Name: newTitle, Link: newLink, Authors: newAuthors, Description: newDescription, Year: newYear)
        //проверка года на число. Проверку решили делать на сервере, пока...
//        if let newYear = Int(yearAdd.text!) {
//            print(newYear)
//            print("name: \(newTitle)\nlink: \(newLink)\nAuthors: \(newAuthors)\nDescription: \(newDescription)\nYear: \(newYear)")
//
//            AddingBook(Name: newTitle, Link: newLink, Authors: newAuthors, Description: newDescription, Year: newYear)
//        } else {
//            print("name: \(newTitle)\nlink: \(newLink)\nAuthors: \(newAuthors)\nDescription: \(newDescription)\nYear: \(0)")
//
//            AddingBook(Name: newTitle, Link: newLink, Authors: newAuthors, Description: newDescription, Year: 0)
//        }
        
        
        
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}