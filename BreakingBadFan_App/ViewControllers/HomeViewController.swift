//
//  BBFanHomeViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

import UIKit

final class HomeViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var quotesButton: CustomButton!
    
    private let doQuotesExist  = {
        QuotesManager.personalFavoriteQuotes.count > 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureView()
    }
    
    // MARK: - IBActions
    
    @IBAction func episodesButtonTapped(_ sender: Any) {
        proceedToEpisodesView()
    }
    
    @IBAction func charactersButtonTapped(_ sender: Any) {
        proceedToCharactersView()
    }
    
    @IBAction func quotesButtonTapped(_ sender: Any) {
        proceedToQuotesView()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        UserDefaultsManager.currentlyLoggedInAccount = nil
    }
    
}

// MARK: - Helpers

private extension HomeViewController {
    
    func configureView() {
        usernameLabel.text = "Welcome: \(UserDefaultsManager.currentlyLoggedInAccount?.username ?? "")"
        quotesButton.isAccesible(isAccesible: doQuotesExist())
    }
}
