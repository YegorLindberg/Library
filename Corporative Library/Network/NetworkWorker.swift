//
//  NetworkWorker.swift
//  Corporative Library
//
//  Created by Moore on 20.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import Foundation
import CFNetwork

class NetworkWorker {
    
    private var isBuisy = false
    var delegateTableVC: TableVC?
    var delegateBookVC: BookVC?
    var delegateAddingBookVC: AddingBookVC?
    private let session = URLSession.shared
    private var task: URLSessionDataTask!
    
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
        
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                if let res = response as? HTTPURLResponse {
                    if res.statusCode >= 200 && res.statusCode < 300 {
                        print("Status O.K.")
                    }
                }
            
                guard let data = data, error == nil, response != nil else {
                    if let delegate = strongSelf.delegateTableVC {
                        delegate.resultAlert(title: "Downloading error:", result: "Please, check your internet connection.")
                    }
                    print("Something with URL is wrong.")
                    strongSelf.isBuisy = false
                    return
                }
                guard error == nil else {
                    strongSelf.isBuisy = false
                    return
                }
                do {
                    let someBooks = try JSONDecoder().decode([Book].self, from: data)
                    if let delegate = strongSelf.delegateTableVC {
                        delegate.updateTableVCWithData(someBooks)
                    }
                    strongSelf.isBuisy = false
                } catch let error {
                    print("Error (loading from Net):", error)
                    strongSelf.isBuisy = false
                }
            }
        task.resume()
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
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                if let res = response as? HTTPURLResponse {
                    if res.statusCode >= 200 && res.statusCode < 300 {
                        print("Status O.K.")
                    }
                }
            
                guard let data = data, error == nil, response != nil else {
                    if let delegate = strongSelf.delegateTableVC {
                        delegate.resultAlert(title: "Downloading error:", result: "Please, check your internet connection.")
                    }
                    strongSelf.isBuisy = false
                    print("Something with URL is wrong.")
                    return
                }
                guard error == nil else {
                    strongSelf.isBuisy = false
                    print("error in searching books. Somtething goes wrong.")
                    return
                }
                do {
                    let someBooks = try JSONDecoder().decode([Book].self, from: data)
                    if let delegate = strongSelf.delegateTableVC {
                        delegate.updateTableVCWithSearchingData(someBooks)
                    }
                    strongSelf.isBuisy = false
                } catch let error {
                    print("Error (loading from Net searching):", error)
                    strongSelf.isBuisy = false
                }
            }
        task.resume()
    }
    
    func postRemoving(id_book: String, remove: Bool) {
        guard !isBuisy else {
            return
        }
        isBuisy = true
        
        let infoAboutBook = ["id":id_book]
        
        var urlString = "https://libraryomega.herokuapp.com/"
        if remove {
            urlString += "books/delete"
        } else {
            urlString += "cancelBooking"
        }
        
        guard let url = URL(string: urlString) else {
            self.isBuisy = false
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: infoAboutBook, options: []) else {
            self.isBuisy = false
            print("something wrong with http body.(post removing)")
            return
        }
        
        request.httpBody = httpBody
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                if let response = response {
                    print(response)
                }
            
                guard let data = data, error == nil, response != nil else {
                    //TODO: alert. Connection error
//                    if let delegate = strongSelf.delegateBookVC {
//                        delegate.resultAlert(title: "Downloading error:", result: "Please, check your internet connection.")
//                    }
                    strongSelf.isBuisy = false
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    strongSelf.isBuisy = false
                    print(json)
                } catch {
                    strongSelf.isBuisy = false
                    print("Error: ", error)
                }
            }
        task.resume()
    }
    
    
    
    func postTake(id_book: String, Name: String) {
        guard !isBuisy else {
            return
        }
        isBuisy = true
        
        let infoAboutBook = ["id":id_book, "name":Name]
        
        let urlString = "https://libraryomega.herokuapp.com/booking"
        guard let url = URL(string: urlString) else {
            self.isBuisy = false
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: infoAboutBook, options: []) else {
            self.isBuisy = false
            print("something wrong with http body.(post take)")
            return
        }
        
        request.httpBody = httpBody
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                if let response = response {
                    print(response)
                }
            
                guard let data = data, error == nil, response != nil else {
                    //TODO: alert. Connection error
//                    if let delegate = strongSelf.delegateBookVC {
//                        delegate.resultAlert(title: "Downloading error:", result: "Please, check your internet connection.")
//                    }
                    strongSelf.isBuisy = false
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    strongSelf.isBuisy = false
                    print(json)
                } catch {
                    strongSelf.isBuisy = false
                    print("Error: ", error)
                }
            }
        task.resume()
    }
    
    
    func AddingBook(Name: String, Link: String, Authors: String, Description: String, Year: String) {
        
        guard !isBuisy else {
            return
        }
        isBuisy = true
        
        let infoAboutBook = ["name":Name, "link":Link, "authors":Authors, "description":Description, "year":Year]// as [String : Any]
        
        let urlString = "https://libraryomega.herokuapp.com/books"
        guard let url = URL(string: urlString) else {
            self.isBuisy = false
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: infoAboutBook, options: []) else {
            self.isBuisy = false
            print("something wrong with http body.(adding book)")
            return
        }
        
        request.httpBody = httpBody
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                if let response = response {
                    print(response)
                }
            
                guard let data = data, error == nil, response != nil else {
                    //TODO: alert. Connection error
//                    if let delegate = strongSelf.delegateAddingBookVC {
//                        delegate.resultAlert(title: "Downloading error:", result: "Please, check your internet connection.")
//                    }
                    strongSelf.isBuisy = false
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    strongSelf.isBuisy = false
                    print(json)
                } catch {
                    strongSelf.isBuisy = false
                    print("Error: ", error)
                }
            }
        task.resume()
    }
    
    
    func cancelTask() {
        if task != nil {
            task.cancel()
            task = nil
        }
    }

}
