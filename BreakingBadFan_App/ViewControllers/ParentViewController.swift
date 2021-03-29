//
//  BBFanParentViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

import UIKit

class ParentViewController: UIViewController {
    
    let apiManager = APIManager()
    let quoteCellNib = UINib(nibName: "QuoteCell", bundle: nil)
    
    func dismissCompletion() {
       dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIViewControllers
    
    private lazy var HomeViewStoryboard: UIStoryboard = {
        UIStoryboard(name: "Home", bundle: nil)
    }()
    
    private lazy var DataViewStoryboard: UIStoryboard = {
        UIStoryboard(name: "Data", bundle: nil)
    }()
    
    private lazy var QuotesViewStoryboard: UIStoryboard = {
        UIStoryboard(name: "Quotes", bundle: nil)
    }()
    
    private var HomeViewController: UIViewController {
        HomeViewStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
    }
}

// MARK: - Transitions

extension ParentViewController {
    
    func proceedToHomeView() {
        modalPresentationStyle = .fullScreen
        present(HomeViewController, animated: true)
    }
    
    func proceedToEpisodesView() {
        if let episodesVC = DataViewStoryboard.instantiateViewController(withIdentifier: "EpisodesDataViewController") as? EpisodesDataViewController {
            self.present(episodesVC, animated: true, completion: nil)
        }
    }
    
    func proceedToCharactersView() {
        if let episodesVC = DataViewStoryboard.instantiateViewController(withIdentifier: "CharactersDataViewController") as? CharactersDataViewController {
            self.present(episodesVC, animated: true, completion: nil)
        }
    }
    
    func proceedToQuotesView() {
        if let quotesVC = QuotesViewStoryboard.instantiateViewController(withIdentifier: "QuotesViewController") as? QuotesViewController {
            self.present(quotesVC, animated: true, completion: nil)
        }
    }
    
    func proceedToCharacterDetailVC(with character: Character) {
        if let characterDetialVC = self.storyboard?.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController {
            characterDetialVC.character = character
            self.present(characterDetialVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Alerts

extension ParentViewController {
    
    func presentAlert(
        title: String,
        message: String,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - View Configuration

extension ParentViewController {
    func configureHeader(view: UIView, fontSize: CGFloat)  {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .none
        header.textLabel?.textColor = #colorLiteral(red: 0.9647058824, green: 0.8431372549, blue: 0.262745098, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
}
