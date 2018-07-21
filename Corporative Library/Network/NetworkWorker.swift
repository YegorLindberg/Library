//
//  NetworkWorker.swift
//  Corporative Library
//
//  Created by Moore on 20.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import Foundation

class NetworkWorker {
    private var isBuisy = false
    var delegate: TableVC?
    
    func loadAndUpdateDataFromNet(page: Int) {
        guard !isBuisy else {
            return
        }
        isBuisy = true
        
        //downloading
        let urlString = "https://libraryomega.herokuapp.com/books/showPage/" + String(page)
        guard let url = URL(string: urlString) else {
            isBuisy = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, response != nil else {
                    print("Something with URL is wrong.")
                    self.isBuisy = false
                    return
                }
                guard error == nil else {
                    self.isBuisy = false
                    return
                }
                do {
                    let someBooks = try JSONDecoder().decode([Book].self, from: data)
                    if let delegate = self.delegate {
                        delegate.updateTableVCWithData(someBooks)
                    }
                    self.isBuisy = false
                } catch let error {
                    print(error)
                    self.isBuisy = false
                }
            }.resume()
    }
    
    func loadSearchingDataFromNet(substring: String) {
        
        guard !isBuisy else {
            return
        }
        isBuisy = true
        
        //make url
        print("search book for substring: \(substring)")
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ".-_")
        let encoded = substring.addingPercentEncoding(withAllowedCharacters: allowed)
        let makedUrl = "https://libraryomega.herokuapp.com/books/searchBook?substring=\(encoded!)"
        print("maked url: \(makedUrl)")
        guard let url = URL(string: makedUrl) else {
            isBuisy = false
            print("URL cancelled error.")
            return
        }
        //download
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, response != nil else {
                    self.isBuisy = false
                    print("Something with URL is wrong.")
                    return
                }
                guard error == nil else {
                    self.isBuisy = false
                    print("error in searching books. Somtething goes wrong.")
                    return
                }
                do {
                    let someBooks = try JSONDecoder().decode([Book].self, from: data)
                    if let delegate = self.delegate {
                        delegate.updateTableVCWithSearchingData(someBooks)
                    }
                    self.isBuisy = false
                } catch let error {
                    print(error)
                    self.isBuisy = false
                }
            }.resume()
    }

}
