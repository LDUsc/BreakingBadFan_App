//
//  EpisodeDetailViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 26/02/2021.
//

import UIKit

final class EpisodeDetailViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var episodeTitleLabel: UILabel!
    @IBOutlet private weak var seasonNumberLabel: UILabel!
    @IBOutlet private weak var EpisodeNumberLabel: UILabel!
    @IBOutlet private weak var airDateLabel: UILabel!
    @IBOutlet private weak var episodeCharactersTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureView()
    }
    
    private func setDelegates() {
        episodeCharactersTableView.delegate = self
        episodeCharactersTableView.dataSource = self
    }
    
    private func configureView() {
        if let episode = episode {
            episodeTitleLabel.text = episode.title
            seasonNumberLabel.text = "Season \(episode.season)"
            EpisodeNumberLabel.text = "Episode \(episode.episode)"
            airDateLabel.text = "Air date: \(episode.airDate)"
        }
        episodeCharactersTableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: - TableView Datasource Methods

extension EpisodeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let episode = episode else { return 1 }
        return episode.characters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Characters"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCharacterCell", for: indexPath)
        cell.textLabel?.text = episode?.characters[indexPath.row]
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension EpisodeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.startAnimating()
        
        CharactersManager.loadCharacters { [weak self] result in
            switch result {
            case .success(_):
                guard
                    let characterName = self?.episode?.characters[indexPath.row],
                    let character = CharactersManager.getSpecificCharacter(fullName: characterName)
                else {
                    self?.presentAlert(
                        title: "Character Not Found!",
                        message: "BB API Can't spell names propperly ¯\\_(ツ)_/¯"
                    )
                    self?.activityIndicator.stopAnimating()
                    return
                }
                self?.activityIndicator.stopAnimating()
                self?.proceedToCharacterDetailVC(with: character)
            case.failure(let error):
                self?.presentAlert(
                    title: "Couldn't get character",
                    message: error.errorDescription,
                    completion: { _ in
                        self?.dismissCompletion()
                    }
                )
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configureHeader(view: view, fontSize: 20)
    }
}
