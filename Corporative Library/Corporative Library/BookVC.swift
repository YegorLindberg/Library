//
//  ViewController.swift
//  Corporative Library
//
//  Created by Moore on 21.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

extension BookVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class BookVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var titleChosenBook: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var availableStatus: UILabel!
    @IBOutlet weak var yearBook: UILabel!
    @IBOutlet weak var descriptionBook: UILabel!
    
    @IBOutlet weak var enteringName: UITextField!
    
    @IBOutlet weak var linkToBookButton: UIButton!
    @IBOutlet weak var changingButton: UIButton!
    
    var postBook: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteringName.delegate = self
        
        currentImage.image = #imageLiteral(resourceName: "emptyImage")
        titleChosenBook.text = postBook.name
        linkToBookButton.setTitle(postBook.link, for: .normal) 
        bookAuthors.text = postBook.authors
        if postBook.available == true {
            changingButton.setTitle("Take this book!", for: UIControlState.normal)
            availableStatus.text = "Book is available now."
        } else {
            changingButton.tintColor = UIColor(red: 50/255.0, green: 205/255.0, blue: 200/255.0, alpha: 1.0)
            changingButton.backgroundColor = UIColor(red: 50/255.0, green: 205/255.0, blue: 200/255.0, alpha: 1.0)
            changingButton.setTitle("Remove reservation", for: UIControlState.normal)
            availableStatus.text = "Book is NOT available now."
        }
        yearBook.text = String(postBook.year)
        descriptionBook.text = postBook.description
        descriptionBook.sizeToFit()
        
        self.HideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    var doubleTap = false
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func manageBook() {
        if postBook.available == true {
            enteringName.isHidden = false
            if doubleTap {
                if enteringName.text != nil && enteringName.text != "" {
                    warningLabel.isHidden = false
                    doubleTap = false
                    postTake(id_book: postBook._id, Name: enteringName.text!)
                    warningLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    warningLabel.text = "Book was reserved by: " + enteringName.text!
                    print("id -add- reservation book: ", postBook._id)
                    print("available\n")
                } else {
                    warningLabel.isHidden = false
                }                
            } else {
                doubleTap = true
            }
        } else {
            print("id -remove- reservation book: ", postBook._id)
            postCancel(id_book: postBook._id)
            print("not-available.\n")
        }
    }
    
    @IBAction func linkToBookButtonWasTapped(_ sender: UIButton) {
        guard let urlToBook = URL(string: postBook.link) else {
            print("link is missing.\n")
            return
        }
        UIApplication.shared.open(urlToBook, options: [:], completionHandler: nil)
        
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


}

