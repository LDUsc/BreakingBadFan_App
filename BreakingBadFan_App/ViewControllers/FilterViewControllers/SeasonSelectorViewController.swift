//
//  SeasonSelectorViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

protocol SeasonSelectorDelegate: AnyObject {
    func didChoseSeason(_ season: [Int])
}

final class SeasonSelectorViewController: FilterParentViewController {
    
    @IBOutlet weak var seasonsTableView: UITableView!
    
    private var selectedRows = [Int]()
    
    weak var delegate: SeasonSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        seasonsTableView.register(cellNib, forCellReuseIdentifier: "FilterCell")
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate?.didChoseSeason(selectedRows)
        dismiss(animated: true, completion: nil)
    }
    
    private func setDelegates() {
        seasonsTableView.delegate = self
        seasonsTableView.dataSource = self
    }
}

// MARK: - TableView DataSource Methods

extension SeasonSelectorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EpisodesManager.seasonNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell
        cell?.configureCell(name: "Season \(EpisodesManager.seasonNumbers[indexPath.row])")
        cell?.accessoryType = self.accessoryForIndexPath(indexPath: indexPath)
        return cell ?? UITableViewCell()
    }
}

// MARK: - TableView Delegate Methods

extension SeasonSelectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRows.contains(indexPath.row) {
            self.selectedRows.removeAll { $0 == indexPath.row}
        } else {
            self.selectedRows.append(indexPath.row)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = self.accessoryForIndexPath(indexPath: indexPath)
            
        }
    }
    
    func accessoryForIndexPath(indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        var accessory = UITableViewCell.AccessoryType.none
        
        if self.selectedRows.contains(indexPath.row) {
            accessory = UITableViewCell.AccessoryType.checkmark
        }
        return accessory
    }
}
