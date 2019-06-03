//
//  ListViewController.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 1/30/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit
import SimCharNetwork

class ListViewController: UIViewController, URLSessionDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var characterViewModel = CharacterViewModel()
    
    var curSelectedCellTitle: String!
    
    var searchActive : Bool = false
        
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredSearchItems: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        characterViewModel.getCharactersData(from: "http://api.duckduckgo.com/?q=the+wire+characters&format=json", completion: {
            self.tableView.reloadData()
        })

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curSelectedCellTitle = (tableView.cellForRow(at: indexPath))?.textLabel?.text ?? ""
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            performSegue(withIdentifier: padTableItemSelectedGoToDetailVC, sender: nil)
        } else {
            performSegue(withIdentifier: phoneTableItemSelectedGoToCharDetailVC, sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if searchActive {
            if let items = filteredSearchItems {
                let item: [String: Any] = items[indexPath.row]
                cell.textLabel!.text = item["text"] as? String
            }
        } else {
            if !searchActive {
                cell.textLabel?.text = characterViewModel.characterNameToDisplay(for: indexPath)
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = filteredSearchItems else {
            return characterViewModel.numberOfItemsToDisplay(in: section)
        }
        return items.count
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow ?? IndexPath(row: 0, section: 0)

        curSelectedCellTitle = (tableView.cellForRow(at: indexPath))?.textLabel?.text ?? ""

        searchController.dismiss(animated: true, completion: nil)

        if UI_USER_INTERFACE_IDIOM() == .phone {
            if let vc = segue.destination as? CharacterDetailViewController {
                if searchActive {
                    if curSelectedCellTitle == nil {
                        vc.indexPath = indexPath
                    } else {
                        vc.indexPath = characterViewModel.characterIdIndexPath(for: curSelectedCellTitle)
                    }
                } else {
                    vc.indexPath = indexPath
                }
                
                vc.characterViewModel = characterViewModel
            }
        } else { // ipad
            if let vc = segue.destination as? DetailViewController {
                if searchActive {
                    vc.indexPath = characterViewModel.characterIdIndexPath(for: curSelectedCellTitle)
                } else {
                    vc.indexPath = indexPath
                }

                vc.characterViewModel = characterViewModel
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchActive = true

        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredSearchItems = characterViewModel.names.filter { item in
                return (item["text"] as! String).lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredSearchItems = characterViewModel.names
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
}
