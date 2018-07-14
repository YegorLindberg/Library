//
//  TableViewController.swift
//  Corporative Library
//
//  Created by Moore on 27.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private func startActiveIndicator() {
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    private func stopActiveIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
//    private var partOfBooks: [Book] = Array()
//    var partOfBooks: [Book] = []
    private var partOfBooks = [Book]()
    private var currentPage = 1
    private var shouldShowLoadingCell = false
    var refresh: UIRefreshControl!
    
    var fetchingMore = false
    var endOfPaging = false

    @IBOutlet var MainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MainTableView.dataSource = self
        MainTableView.delegate = self

        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        
        self.refresh.addTarget(self, action: #selector(TableVC.downloadFirstPage), for: UIControlEvents.valueChanged)
        self.refresh.tintColor = UIColor.gray
        tableView.addSubview(refresh)
        self.refresh.beginRefreshing()
        
        downloadFirstPage()
  
        // --- Get-requests to load new data(pages)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func downloadFirstPage() {
        self.fetchingMore = true
        currentPage = 1
        endOfPaging = false
        loadBooks(refresh: true)
    }
    
    func loadBooks(refresh: Bool = false) {
        if refresh == false {
            currentPage += 1
        }
        print("fetch page: \(self.currentPage)")
        downloadPage(page: self.currentPage)
    }
    
    func downloadPage(page: Int) {
        let urlString = "https://libraryomega.herokuapp.com/books/showPage/" + String(page)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, response != nil else {
                    print("Something with URL is wrong.")
                    return
                }
                guard error == nil else { return }
                do {
                    let someBooks = try JSONDecoder().decode([Book].self, from: data)
                    if someBooks.count == 0 {
                        print("empty array was made. Last page is \(self.currentPage - 1)\n")
                        self.endOfPaging = true
                    } else {
                        if page == 1 {
                            self.partOfBooks = someBooks
                        } else {
                            self.partOfBooks += someBooks
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.fetchingMore = false
                        
                        print("this is NetWork sent(inside):\n\(self.partOfBooks)\n\n")
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        self.refresh?.endRefreshing()
        if page != 1 {
            self.stopActiveIndicator()
        }        
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
        return self.partOfBooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        
        // Configure the cell...
        cell.populate(with: partOfBooks[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    //sent data to another VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectBook", sender: partOfBooks[indexPath.item])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBook" {
            if let selectedBook = sender as? Book, let destinationViewController = segue.destination as? BookVC {
                destinationViewController.postBook = selectedBook
            }
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        //print("offset y: \(offsetY), scroll height: \(contentHeight)")
        if !endOfPaging {
            if offsetY > contentHeight - scrollView.frame.height {
                if self.fetchingMore == false {
                    beginBatchFetch()
                }
            }
        }
    }
    func beginBatchFetch() {
        startActiveIndicator()
        self.fetchingMore = true
        print("beginBatchFetch!")
        loadBooks()
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
