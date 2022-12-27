//
//  FiltersViewController.swift
//  TemplateOfDealsViewer
//
//  Created by Pasha on 24.12.2022.
//

import UIKit

public enum Filters: String, CaseIterable {
    case dateDefault
    case instrASC
    case instrDESC
    case priceASC
    case priceDESC
    case amountASC
    case amountDESC
    case buyFirst
    case sellFirst
}



class FiltersViewController: UITableViewController {
    public var completion: ((Filters) -> Void)?
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterModeCell")
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Filters.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterModeCell", for: indexPath)
        cell.textLabel?.text = Filters.allCases[indexPath.row].rawValue
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        completion?(Filters.allCases[indexPath.row])
        self.dismiss(animated: true)
    }
    
}
