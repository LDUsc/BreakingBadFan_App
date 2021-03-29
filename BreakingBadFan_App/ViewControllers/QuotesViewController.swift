//
//  QuotesTableViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 01/03/2021.
//

import UIKit

final class QuotesViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var quotesTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navigationBar: CustomNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRandomQuote()
        setDelegates()
        configureView()
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helpers

private extension QuotesViewController {
    
    func setDelegates() {
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
    }
    
    func configureView() {
        quotesTableView.register(quoteCellNib, forCellReuseIdentifier: "QuoteCell")
        navigationBar.topItem?.title = "Quotes"
    }
    
    func getRandomQuote() {
        activityIndicator.startAnimating()
        QuotesManager.getRandomQuote { [weak self] result in
            switch result {
            case .success(_):
                self?.animatedReloadTableView()
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.activityIndicator.stopAnimating()
                self?.presentAlert(
                    title: "Couldn't get random quote",
                    message: "Reson: \(error.errorDescription)",
                    completion: { _ in
                        self?.dismissCompletion()
                    }
                )
            }
        }
    }
}

// MARK: - TableView DataSource Methods

extension QuotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return QuotesManager.quotesData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        QuotesManager.quotesData[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        QuotesManager.quotesData[section].quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell {
            let quote = QuotesManager.quotesData[indexPath.section].quotes[indexPath.row]
            QuotesManager.isQuoteFavorite(quote) { result in
                cell.configureFavoriteQuoteIcon(isFavorite: result)
            }
            
            if indexPath.section != 2 {
                cell.quoteLabel.text = quote.quote
                cell.countLabel.isHidden = true
            } else {
                cell.countLabel.isHidden = false
                cell.quoteLabel.text = quote.quote
                cell.countLabel.text = "Number of likes: \(QuotesManager.getQuoteCount(quote))"
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate Methods

extension QuotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? QuoteCell {
            let selectedQuote = QuotesManager.quotesData[indexPath.section].quotes[indexPath.row]
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
        QuotesManager.loadQuotesForTableView()
        animatedReloadTableView()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { 
        let selectedQuote = QuotesManager.quotesData[indexPath.section].quotes[indexPath.row]
        
        QuotesManager.removeQuoteFromFavorite(selectedQuote)
        if editingStyle == .delete {
            QuotesManager.quotesData[indexPath.section].quotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        animatedReloadTableView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configureHeader(view: view, fontSize: 20)
    }
    
    func animatedReloadTableView() {
        UIView.transition(
            with: quotesTableView,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.quotesTableView.reloadData()
            }, completion: nil)
    }
}
