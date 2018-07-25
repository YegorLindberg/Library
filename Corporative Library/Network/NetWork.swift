//
//  NetWork.swift
//  Corporative Library
//
//  Created by Moore on 02.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import Foundation

func postRemoving(id_book: String, remove: Bool) {
    
    let infoAboutBook = ["id":id_book]
    
    var urlString = "https://libraryomega.herokuapp.com/"
    if remove {
        urlString += "books/delete"
    } else {
        urlString += "cancelBooking"
    }
    
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


func AddingBook(Name: String, Link: String, Authors: String, Description: String, Year: String) {

    let infoAboutBook = ["name":Name, "link":Link, "authors":Authors, "description":Description, "year":Year]// as [String : Any]
    
    let urlString = "https://libraryomega.herokuapp.com/books"
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





