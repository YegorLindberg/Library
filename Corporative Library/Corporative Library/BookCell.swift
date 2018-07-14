//
//  TableViewCell.swift
//  Corporative Library
//
//  Created by Moore on 28.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

class BookCell: UITableViewCell {
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var BookName: UILabel!
    @IBOutlet weak var AuthorName: UILabel!
    @IBOutlet weak var availableValue: UILabel!
    
    @IBOutlet weak var characterImage: UIImageView!
    
    private func setupSubviews() {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .gray
        indicator.hidesWhenStopped = true
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        indicator.startAnimating()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        BookName.text?.removeAll()
//        AuthorName.text?.removeAll()
//        availableValue.text?.removeAll()
//
//        characterImage.image = nil
//    }
    
    func populate(with book: Book) {
        BookName.text = book.name
        AuthorName.text = book.authors
        if book.available == true {
            availableValue.text = "Available."
        } else {
            availableValue.text = "Not available."
        }
        //        if book.image != "none" {
        //            if let imageURL = URL(string: book.image) {
        //                DispatchQueue.global().async {
        //                    let data = try? Data(contentsOf: imageURL)
        //                    if let data = data {
        //                        let image = UIImage(data: data)
        //                        DispatchQueue.main.async {
        //                            characterImage.image = image
        //                        }
        //                    }
        //                }
        //            }
        //        } else {
        //            DispatchQueue.main.async {
        characterImage.image = #imageLiteral(resourceName: "emptyImage")
        //            }
        //        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


