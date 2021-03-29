//
//  FilterEpisodesViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

protocol FilterEpisodesDelegate: AnyObject {
    func didApplyEpisodesFilter(
        seasons: [Int]?,
        fromDate: String?,
        toDate: String?,
        characters: [String]?
    )
}

final class FilterEpisodesViewController: FilterParentViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet private weak var selectSeasonsButton: UIButton!
    @IBOutlet private weak var fromDateTextField: FilterDateTextField!
    @IBOutlet private weak var toDateTextField: FilterDateTextField!
    @IBOutlet private weak var charactersTableView: FilterTableView!
    
    // MARK: - Properties
    
    private var toDatePicker = FilterDatePicker()
    private var fromDatePicker = FilterDatePicker()
    
    private var selectedRows = [Int]()
    private var selectedSeasons = [Int]()
    private var selectedFromDate = String()
    private var selectedToDate = String()
    private var selectedCharacters: [String] {
        return selectedRows.map {  EpisodesManager.charactersInEpisode[$0] }
    }
    
    private var firstEpisodeDate: Date {
        guard let firstDate = EpisodesManager.episodes.first?.date else {
            return Date(timeIntervalSince1970: 1199222427)
        }
        return firstDate
    }
    
    private var lastEpisodeDate: Date {
        guard let lastDate = EpisodesManager.episodes.last?.date else {
            return Date(timeIntervalSince1970: 1380486027)
        }
        return lastDate
    }

    weak var delegate: FilterEpisodesDelegate?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setDelegates()
        configureDatePickers()
        
        fromDateTextField.inputView = fromDatePicker
        toDateTextField.inputView = toDatePicker
    }
    
    // MARK: - IBActions
    
    @IBAction func selectSeasonsButtonTapped(_ sender: Any) {
        let seasonVC = SeasonSelectorViewController()
        seasonVC.modalPresentationStyle = .popover
        seasonVC.delegate = self
        present(seasonVC, animated: true, completion: nil)
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
       applyFilterIfSelectionsExist()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Helpers

private extension FilterEpisodesViewController {
    
    func setDelegates() {
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
    }
    
    func configureDatePickers() {
        fromDatePicker.date = firstEpisodeDate
        fromDatePicker.minimumDate = firstEpisodeDate
        fromDatePicker.maximumDate = lastEpisodeDate
        toDatePicker.minimumDate = firstEpisodeDate
        toDatePicker.maximumDate = lastEpisodeDate
        fromDatePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        toDatePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
    }
    
    func setupTableView() {
        charactersTableView.register(cellNib, forCellReuseIdentifier: "FilterCell")
    }
}

// MARK: - Selection Validation

private extension FilterEpisodesViewController {
    
    func applyFilterIfSelectionsExist() {
        checkSelections { [weak self] completion in
            switch completion {
            case true:
                self?.delegate?.didApplyEpisodesFilter(
                    seasons: self?.selectedSeasons,
                    fromDate: self?.fromDateTextField.text ?? "",
                    toDate: self?.toDateTextField.text ?? "",
                    characters: self?.selectedCharacters
                )
                self?.dismiss(animated: true, completion: nil)
            case false:
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkSelections(completion: @escaping BoolCompletion) {
        guard
            selectedSeasons.isNotEmpty ||
                checkIfTextFieldEmpty(textField: fromDateTextField) ||
                checkIfTextFieldEmpty(textField: toDateTextField) ||
                selectedCharacters.isNotEmpty
        else {
            completion(false)
            return
        }
        completion(true)
    }
    
    func checkIfTextFieldEmpty(textField: UITextField? ) -> Bool {
        guard
            let textFieldText = textField?.text,
            textFieldText.isNotEmpty
        else {
            return false
        }
        return true
    }
}

// MARK: - TableView DataSource Methods

extension FilterEpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EpisodesManager.charactersInEpisode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell {
        cell.configureCell(name: "\(EpisodesManager.charactersInEpisode[indexPath.row])")
        cell.accessoryType = self.accessoryForIndexPath(indexPath: indexPath)
        return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableViewDelegate Methods

extension FilterEpisodesViewController: UITableViewDelegate {
    
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
    
    // MARK: - TableViewDelegate Helper Methods
    
    func accessoryForIndexPath(indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        var accessory = UITableViewCell.AccessoryType.none
        
        if self.selectedRows.contains(indexPath.row) {
            accessory = UITableViewCell.AccessoryType.checkmark
        }
        return accessory
    }
}

// MARK: - TextField Delegate Methods

extension FilterEpisodesViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        fromDatePicker.maximumDate = toDatePicker.date
        toDatePicker.minimumDate = fromDatePicker.date
        fromDateTextField.inputView = fromDatePicker
        toDateTextField.inputView = toDatePicker
    }
}

// MARK: - SeasonSelector Delegate Methods


extension FilterEpisodesViewController: SeasonSelectorDelegate {
    
    func didChoseSeason(_ season: [Int]) {
        selectedSeasons = season
        selectSeasonsButton.setTitle("\(season.map { String($0 + 1) }.joined(separator: " / "))", for: .normal)
    }
}
