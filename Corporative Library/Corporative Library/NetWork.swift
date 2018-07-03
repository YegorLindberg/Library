//
//  NetWork.swift
//  Corporative Library
//
//  Created by Moore on 02.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import Foundation

func downloadNextPage(page: Int) -> [Book] {
    var partOfBooks = [Book]()
    let urlString = "https://libraryomega.herokuapp.com/books/showPage/" + String(page)
    guard let url = URL(string: urlString) else { return [] }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard let data = data, error == nil, response != nil else {
            print("Something with URL is wrong.")
            return
        }
        guard error == nil else { return }
        do {
            let someBooks = try JSONDecoder().decode([Book].self, from: data)
                partOfBooks = someBooks
            print(someBooks[0].name, "\n")
        } catch let error {
            print(error)
        }
    }.resume()
    return partOfBooks
}



func postCancel(id_book: String) {

    print(id_book)
    
    let infoAboutBook = ["id":id_book]
    
    let urlString = "https://libraryomega.herokuapp.com/cancelBooking"
    guard let url = URL(string: urlString) else { return }
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
    guard let httpBody = try? JSONSerialization.data(withJSONObject: infoAboutBook, options: []) else { return }
    
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let response = response {
            print(response)
        }
        
        guard let data = data else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        } catch {
            print("Error: ", error)
        }
    }.resume()
}



func postTake(id_book: String, Name: String) {
    
    print(id_book)
    
    //let takedBook: takeBook = .init(id: id_book, name: Name)
    let infoAboutBook = ["id":id_book, "name":Name]
    
    let urlString = "https://libraryomega.herokuapp.com/booking"
    guard let url = URL(string: urlString) else { return }
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    guard let httpBody = try? JSONSerialization.data(withJSONObject: infoAboutBook, options: []) else { return }
    
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let response = response {
            print(response)
        }
        
        guard let data = data else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        } catch {
            print("Error: ", error)
        }
    }.resume()
}






