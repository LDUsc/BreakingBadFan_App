//
//  CharacterDetailViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 26/02/2021.
//

import UIKit

final class CharacterDetailViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var noQuotesImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var birthDateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var quotesTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var character: Character?
    var characterQuotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setupTableView()
        configureView()
        getCharacterQuotes()
    }
}

// MARK: - Helpers

extension CharacterDetailViewController {
    
    func configureView() {
        if let character = character {
        characterImageView.loadImageFromUrl(urlString: character.image)
        nameLabel.text = character.name
        birthDateLabel.text = "Birth Date: \(character.birthday)"
        statusLabel.text = "Status: \(character.lifeStatus)"
        }
        noQuotesImageView.isHidden =  true
    }
    
    func setupTableView() {
        quotesTableView.register(quoteCellNib, forCellReuseIdentifier: "QuoteCell")
        quotesTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setDelegates() {
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
    }
    
    func getCharacterName() -> String {
        guard let characterName = character?.name else {
            print("Error getting character's name")
            return ""
        }
        return characterName
    }
    
    func getCharacterQuotes() {
        activityIndicator.startAnimating()
        apiManager.getSpecificCharacterQuotesFromAPI(character: getCharacterName()) { [weak self] result in
            switch result {
            case .success(let quotes):
                self?.characterQuotes = quotes
                self?.activityIndicator.stopAnimating()
                self?.quotesTableView.reloadData()
                self?.setupNoQuotesLogo()
            case .failure(let error):
                self?.presentAlert(
                    title: "Couldn't get character's quotes",
                    message: "Reason: \(error.errorDescription)"
                )
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setupNoQuotesLogo() {
        self.noQuotesImageView.isHidden = characterQuotes.isNotEmpty
    }
}

// MARK: - TableView DataSource Methods

extension CharacterDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Character quotes:"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characterQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell {
            let quoteInCell = characterQuotes[indexPath.row]
            QuotesManager.isQuoteFavorite(quoteInCell) { result in
                cell.configureFavoriteQuoteIcon(isFavorite: result)
            }
            cell.quoteLabel.text = characterQuotes[indexPath.row].quote
            cell.countLabel.isHidden = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate Methods

extension CharacterDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? QuoteCell {
            let selectedQuote = characterQuotes[indexPath.row]
            
            QuotesManager.isQuoteFavorite(selectedQuote) { result in
                switch result {
                case true:
                    QuotesManager.removeQuoteFromFavorite(selectedQuote)
                    cell.configureFavoriteQuoteIcon(isFavorite: false)
                case false:
                    QuotesManager.saveQuoteAsFavorite(selectedQuote)
                    cell.configureFavoriteQuoteIcon(isFavorite: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configureHeader(view: view, fontSize: 20)
    }
}
