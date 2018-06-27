//
//  ViewController.swift
//  Corporative Library
//
//  Created by Moore on 21.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

struct Author: Decodable {
    var surname: String
    var name   : String
}

struct someBook: Decodable {
    var name       : String
    var authors    : [Author]
    var available  : String
    var year       : String
    var description: String
    var link       : String
}


class ViewController: UIViewController {

    @IBOutlet weak var firstBookNameLabel: UILabel!
    
    func setLabelWithBookName(_ book: String) {
        firstBookNameLabel.text = book
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelWithBookName("Some name")
        
        let urlString = "http://private-0fc390-corporative0library.apiary-mock.com/simplebook.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let someNewBook = try JSONDecoder().decode(someBook.self, from: data)
                print(someNewBook, "\n")
                print(someNewBook.link as Any, "\n")
                print(someNewBook.authors[0].name, "\n")
                print("\n")
            } catch let error {
                print(error)
            }
            
        }.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


}

