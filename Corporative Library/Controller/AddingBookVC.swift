//
//  AddingBookController.swift
//  Corporative Library
//
//  Created by Moore on 08.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class AddingBookVC: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleAdd: UITextField!
    @IBOutlet weak var yearAdd: UITextField!
    @IBOutlet weak var linkAdd: UITextField!
    @IBOutlet weak var descriptionAdd: UITextField!
    @IBOutlet weak var authorsAdd: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleAdd.delegate = self
        self.yearAdd.delegate = self
        self.linkAdd.delegate = self
        self.descriptionAdd.delegate = self
        self.authorsAdd.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardDidHide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func hideKeyboard() {
        titleAdd.resignFirstResponder()
        yearAdd.resignFirstResponder()
        linkAdd.resignFirstResponder()
        descriptionAdd.resignFirstResponder()
        authorsAdd.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
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
    
    func resultAlert(title: String, result: String) {
        let resAlert = UIAlertController(title: title, message: result, preferredStyle: .alert)
        let confirmResult = UIAlertAction(title: "Ok", style: .default, handler: nil)
        resAlert.addAction(confirmResult)
        self.present(resAlert, animated: true, completion: nil)
    }
    
    @IBAction func AddingTapped(_ sender: UIButton) {
        let newTitle = titleAdd.text!
        let newLink = linkAdd.text!
        let newAuthors = authorsAdd.text!
        let newDescription = descriptionAdd.text!
        let newYear = yearAdd.text!
        hideKeyboard()
        AddingBook(Name: newTitle, Link: newLink, Authors: newAuthors, Description: newDescription, Year: newYear)
        resultAlert(title: "Adding book...", result: "If you have correctly completed all fields, you will be able to see your book list now!\nP.S. Year of the book must be an integer.")
        
    }

}
