//
//  FilterViewController.swift
//  codemash
//
//  Created by Kim Arnett on 12/14/17.
//  Copyright © 2017 karnett. All rights reserved.
//

import Foundation
import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FiltersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        viewModel.saveSelectedFilters()
        self.dismiss(animated: true, completion: {})
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFiltersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterTableViewCell
        
        if let filter = viewModel.getFilterAtIndex(row: indexPath.row) {
            cell?.label.text = filter
            cell?.check.isOn = viewModel.isFilterSelected(index: indexPath.row)
            cell?.check.tag = indexPath.row
            cell?.check.addTarget(self, action: #selector(checkChanged(_:)), for: .valueChanged)
        }
        return cell!
    }
    
    func checkChanged(_ sender: UISwitch) {
        viewModel.updateFilterAtIndex(filterIndex: sender.tag, selected: sender.isOn)
    }
}
