//
//  TableViewController.swift
//  Corporative Library
//
//  Created by Moore on 27.06.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class TableVC: UITableViewController, UISearchBarDelegate {

    let networkWorker = NetworkWorker()

    @IBOutlet weak var searchBar: UISearchBar!

    private var partOfBooks = [Book]()
    private var currentSelectedBooks = [Book]() // update the table
    private var currentPage = 0
    private var shouldShowLoadingCell = false
    var refresh: UIRefreshControl!
    var selectedBarIndex = 0
    
    var fetchingMore = false
    var endOfPaging = false

    @IBOutlet var MainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        
        self.refresh.addTarget(self, action: #selector(TableVC.downloadFirstPage), for: UIControlEvents.valueChanged)
        self.refresh.tintColor = UIColor.gray
        MainTableView.addSubview(refresh)
        self.refresh.beginRefreshing()
        
        downloadFirstPage()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search book by name"
        searchBar.tintColor = UIColor.gray
        searchBar.enablesReturnKeyAutomatically = true
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
        self.selectedBarIndex = self.searchBar.selectedScopeButtonIndex
        print("fetch page: \(self.currentPage)")
        
        networkWorker.delegate = self
        networkWorker.loadAndUpdateDataFromNet(page: currentPage)
    }
    
    func updateTableVCWithData(_ data: [Book]) {
        if data.count == 0 {
            print("empty array was made. Last page is \(currentPage - 1)\n")
            endOfPaging = true
            DispatchQueue.main.async {
                self.refresh?.endRefreshing()
                self.MainTableView.tableFooterView?.isHidden = true
            }
        } else {
            if currentPage == 1 {
                partOfBooks = data
            } else {
                partOfBooks += data
            }
            currentSelectedBooks = partOfBooks
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700), execute: {
                self.MainTableView.reloadData()
                print("in main queue")
                self.refresh?.endRefreshing()
                defer {
                    self.fetchingMore = false
                    self.MainTableView.tableFooterView?.isHidden = true
                }
            })
        }
    }
    
    func updateTableVCWithSearchingData(_ data: [Book]) {
        currentSelectedBooks = data
        DispatchQueue.main.async {
            self.MainTableView.reloadData()
            self.refresh?.endRefreshing()
        }
    }
    
    /// search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.isSearchResultsButtonSelected == true {
            currentSelectedBooks = partOfBooks
        } else {
            currentSelectedBooks = partOfBooks.filter({ book -> Bool in
                switch searchBar.selectedScopeButtonIndex {
                case 0:
                    if searchText.isEmpty {
                        return true
                    }
                    return book.name.lowercased().contains(searchText.lowercased())
                case 1:
                    if searchText.isEmpty {
                        return book.available == true
                    }
                    return book.name.lowercased().contains(searchText.lowercased()) && book.available == true
                case 2:
                    if searchText.isEmpty {
                        return book.available == false
                    }
                    return book.name.lowercased().contains(searchText.lowercased()) && book.available == false
                default:
                    return false
                }
            })
        }
        MainTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search Bar Search Button Clicked")
        searchBar.resignFirstResponder()
        networkWorker.loadSearchingDataFromNet(substring: (self.searchBar.text)!)
    }
    
    var currentScope = 0
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentScope = 0
            currentSelectedBooks = partOfBooks
        case 1:
            currentScope = 1
            currentSelectedBooks = partOfBooks.filter({ book -> Bool in
                book.available == true
            })
        case 2:
            currentScope = 2
            currentSelectedBooks = partOfBooks.filter({ book -> Bool in
                book.available == false
            })
        default:
            break
        }
        MainTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentSelectedBooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        // Configure the cell...
        cell.populate(with: currentSelectedBooks[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    /// sent data to another VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectBook", sender: currentSelectedBooks[indexPath.item])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBook" {
            if let selectedBook = sender as? Book, let destinationViewController = segue.destination as? BookVC {
                destinationViewController.postBook = selectedBook
            }
        }
    }
    
    /// infinite scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        MainTableView.showsVerticalScrollIndicator = true
        if currentScope == 0 {
            if !endOfPaging {
                if offsetY > contentHeight - scrollView.frame.size.height {
                    if fetchingMore == false {
                        beginBatchFetch()
                    }
                }

            }
        }
    }
    func beginBatchFetch() {
        fetchingMore = true
        print("\n\nbeginBatchFetch!")
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.accessibilityLabel = "Downloading more books..."
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.MainTableView.tableFooterView = spinner
        self.MainTableView.tableFooterView?.isHidden = false
        loadBooks()
    }
    
    func resultAlert(title: String, result: String) {
        let resAlert = UIAlertController(title: title, message: result, preferredStyle: .alert)
        let confirmResult = UIAlertAction(title: "Ok", style: .default, handler: nil)
        resAlert.addAction(confirmResult)
        self.present(resAlert, animated: true, completion: nil)
    }

}
