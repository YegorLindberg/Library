//
//  Book.swift
//  Corporative Library
//
//  Created by Moore on 28.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class Book: Codable {
    var _id        : String
    var name       : String
    var link       : String
    var authors    : String
    var available  : Bool
    var description: String
    var year       : Int
    
    init(_id: String, name: String, link: String, authors: String, available: Bool, description: String, year: Int) {
        self._id = _id
        self.name = name
        self.link = link
        self.authors = authors
        self.available = available
        self.description = description
        self.year = year
    }
}
