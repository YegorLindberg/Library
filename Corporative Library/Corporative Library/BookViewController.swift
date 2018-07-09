//
//  ViewController.swift
//  Corporative Library
//
//  Created by Moore on 21.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func manageBook() {
        if postBook.available == true {
            print("id posted book: ", postBook._id)
            //TODO: сделать проверку на заполненность поля имени и далее снова нажать на button(кнопку), чтобы забронировать книгу.
            postTake(id_book: postBook._id, Name: "Yegor")
            print("true\n")
        } else {
            print("id posted book: ", postBook._id)
            postCancel(id_book: postBook._id)
            print("false\n")
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

