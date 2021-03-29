//
//  FilterCharactersViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 02/03/2021.
//

import UIKit

protocol FilterCharactersDelegate: AnyObject {
    func didApplyCharactersFilter(lifeStatus: String?, selectedSeasons: [Int]?)
}

final class FilterCharactersViewController: FilterParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var statusPickerView: CustomPickerView!
    @IBOutlet var seasonsTableView: FilterTableView!
    
    // MARK: - Properties
    
    private var selectedLifeStatus: String?
    private var selectedRows = [Int]()
    
    private var lifeStatus: [String] = {
        let status = CharactersManager.characters.map( { $0.lifeStatus } )
        return status.removeDuplicates()
    } ()
    private var seasonNumbers = [Int]()
    
    weak var delegate: FilterCharactersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonsTableView.register(cellNib, forCellReuseIdentifier: "FilterCell")
        setDelegates()
        setSeasonNumbers()
    }
    
    // MARK: - IBActions
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        applyFilterIfSelectionsExist()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Helpers

private extension FilterCharactersViewController {
    
    func setDelegates() {
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        seasonsTableView.delegate = self
        seasonsTableView.dataSource = self
    }
    
    func setSeasonNumbers() {
        let seasonNum = CharactersManager.characters.map { $0.seasons }
        
        seasonNumbers =  seasonNum
            .joined()
            .compactMap { $0 }
            .removeDuplicates()
    }
}

// MARK: - Parameter Validation

private extension FilterCharactersViewController {
    
    func applyFilterIfSelectionsExist() {
        checkSelections { [weak self] completion in
            switch completion {
            case true:
                self?.delegate?.didApplyCharactersFilter(
                    lifeStatus: self?.selectedLifeStatus,
                    selectedSeasons: self?.selectedRows
                )
                
                self?.dismiss(animated: true, completion: nil)
            case false:
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkSelections(completion: @escaping BoolCompletion) {
        guard
            selectedRows.isNotEmpty ||
                selectedLifeStatus != nil
        else {
            completion(false)
            return
        }
        completion(true)
    }
}

// MARK: - UIPickerView Delegate & DataSource Methods

extension FilterCharactersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lifeStatus.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        row == 0 ? "Select life Status" : lifeStatus[row - 1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row > 0 else {
            selectedLifeStatus = nil
                return
        }
        selectedLifeStatus = lifeStatus[row - 1]
    }
}

// MARK: - TableView DataSource Methods

extension FilterCharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasonNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell {
            cell.configureCell(name: "Season \(seasonNumbers[indexPath.row])")
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate Methods

extension FilterCharactersViewController: UITableViewDelegate {
    
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
