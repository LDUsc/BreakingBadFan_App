//
//  BBEpisodesViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

final class CharactersDataViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: CustomNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureView()
        getDataForTableview()
    }
    
    // MARK: - IBActions
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.proceedToFilterCharactersView()
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        CharactersManager.reloadCharactersData()
        tableView.reloadData()
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helpers

private extension CharactersDataViewController {
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureView() {
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.title = "Characters"
    }
}

// MARK: - Data Methods

private extension CharactersDataViewController {
    func getDataForTableview() {
        activityIndicator.startAnimating()
        getCharactersForTableView()
    }
    
    func getCharactersForTableView() {
        CharactersManager.loadCharacters { [weak self] result in
            switch result {
            case .success(_):
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.presentAlert(
                    title: "Couldn't get characters data",
                    message: error.errorDescription,
                    completion: { _ in
                        self?.dismissCompletion()
                    }
                )
            }
        }
    }
}

// MARK: - TableView Datasource Methods

extension CharactersDataViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CharactersManager.charactersData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CharactersManager.charactersData[section].sectionLetter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CharactersManager.charactersData[section].characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        let character = CharactersManager.charactersData[indexPath.section].characters[indexPath.row]
        
        cell.textLabel?.text = "\(character.name)"
        cell.detailTextLabel?.isHidden = true
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension CharactersDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            proceedToCharacterDetailsView(characterSection: indexPath.section, characterIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configureHeader(view: view, fontSize: 20)
    }
}

// MARK: - CharactersFilter Delegate Methods

extension CharactersDataViewController: FilterCharactersDelegate {
    
    func didApplyCharactersFilter(lifeStatus: String?, selectedSeasons: [Int]?) {
        CharactersManager.filterCharactersData(lifeStatus: lifeStatus, seasons: selectedSeasons)
        tableView.reloadData()
    }
}

// MARK: - Transitions

private extension CharactersDataViewController {
    
    func proceedToFilterCharactersView() {
        let filterCharactersVC = FilterCharactersViewController()
        filterCharactersVC.modalPresentationStyle = .popover
        filterCharactersVC.delegate = self
        present(filterCharactersVC, animated: true)
    }
    
    func proceedToCharacterDetailsView(characterSection: Int, characterIndex: Int) {
        if let characterDetialVC = self.storyboard?.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController {
            characterDetialVC.character = CharactersManager.charactersData[characterSection].characters[characterIndex]
            self.present(characterDetialVC, animated: true, completion: nil)
        }
    }
}
