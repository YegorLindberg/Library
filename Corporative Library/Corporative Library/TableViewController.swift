//
//  TableViewController.swift
//  Corporative Library
//
//  Created by Moore on 27.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var partOfBooks = [Book]()
    
    func downloadJson() {
        let urlString = "https://private-0fc390-corporative0library.apiary-mock.com/simplebook.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil, response != nil else {
                print("Something with URL is wrong.")
                return
            }
            guard error == nil else { return }
            do {
                let someBooks = try JSONDecoder().decode([Book].self, from: data)
                self.partOfBooks = someBooks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(someBooks[0].name, "\n")
                print(someBooks[1].name, "\n")
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJson()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return partOfBooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else { return UITableViewCell() }
        
        // Configure the cell...
        cell.BookName.text = partOfBooks[indexPath.row].name
        cell.AuthorName.text = partOfBooks[indexPath.row].authors
        if partOfBooks[indexPath.row].available == true {
            cell.availableValue.text = "Available."
        } else {
            cell.availableValue.text = "Not available."
        }
        
        if partOfBooks[indexPath.row].image != "none" {
            if let imageURL = URL(string: partOfBooks[indexPath.row].image) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.characterImage.image = image
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                cell.characterImage.image = #imageLiteral(resourceName: "emptyImage")
            }
        }
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 196.0
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
