//
//  ViewController.swift
//  Corporative Library
//
//  Created by Moore on 21.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class BookVC: UIViewController {
    var postBook: Book!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var titleChosenBook: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var availableStatus: UILabel!
    @IBOutlet weak var yearBook: UILabel!
    @IBOutlet weak var descriptionBook: UILabel!
    
    @IBOutlet weak var linkToBookButton: UIButton!
    @IBOutlet weak var changingButton: UIButton!
    
    @IBAction func deleteBook(_ sender: UIBarButtonItem) {
        alertFromRemove(title: "Are you sure you want to remove this book ?", message: nil)
    }
    
    func alertFromRemove(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            postRemoving(id_book: self.postBook._id, remove: true)
            self.resultAlert(result: "Book successfully deleted.")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertToManageBook() {
        let manageAlert = UIAlertController(title: "Confirm the action!", message: nil, preferredStyle: .alert)
        if postBook.available == true {
            manageAlert.addTextField { (textField) in
                textField.placeholder = "Enter your name here..."
                textField.keyboardType = .asciiCapable
                
            }
            let confirmAction = UIAlertAction(title: "Take!", style: .default, handler: { (action) in
                if (manageAlert.textFields?.first?.text != nil) && (manageAlert.textFields?.first?.text != "") {
                    postTake(id_book: self.postBook._id, Name: manageAlert.textFields!.first!.text!)
                    self.resultAlert(result: "Book successfully reserved!")
                } else {
                    self.resultAlert(result: "Book wasn't reservation, because you have not entered your name.")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            })
            manageAlert.addAction(confirmAction)
            manageAlert.addAction(cancelAction)
        } else {
            let confirmAction = UIAlertAction(title: "Release", style: .default) { (action) in
                postRemoving(id_book: self.postBook._id, remove: false)
                self.resultAlert(result: "Book successfully free.")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            }
            manageAlert.addAction(confirmAction)
            manageAlert.addAction(cancelAction)
        }
        self.present(manageAlert, animated: true, completion: nil)
    }
    
    func resultAlert(result: String) {
        let resAlert = UIAlertController(title: nil, message: result, preferredStyle: .alert)
        let confirmResult = UIAlertAction(title: "Ok", style: .default, handler: nil)
        resAlert.addAction(confirmResult)
        self.present(resAlert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    
    @IBAction func manageBook() {
        alertToManageBook()
    }
    
    @IBAction func linkToBookButtonWasTapped(_ sender: UIButton) {
        guard let urlToBook = URL(string: postBook.link) else {
            print("link is missing.\n")
            return
        }
        UIApplication.shared.open(urlToBook, options: [:], completionHandler: nil)
    }

}

