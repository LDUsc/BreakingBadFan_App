//
//  BBEpisodesViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

final class EpisodesDataViewController: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navigationBar: CustomNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureView()
        getDataForTableview()
    }
    
    // MARK: - IBActions
    
    @IBAction func sortButtonTapped(_ sender: Any) {
            self.proceedToFilterEpisodesView()
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
            EpisodesManager.reloadEpisodesData()
            tableView.reloadData()
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helpers

private extension EpisodesDataViewController {
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureView() {
        navigationBar.prefersLargeTitles = true
            navigationBar.topItem?.title = "Episodes"
    }
}

// MARK: - Data Methods

private extension EpisodesDataViewController {
    
    func getDataForTableview() {
        activityIndicator.startAnimating()
            getEpisodesForTableView()
    }
    
    func getEpisodesForTableView() {
        EpisodesManager.loadEpisodes { [weak self] result in
            switch result {
            case .success(_):
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.presentAlert(
                    title: "Couldn't get episodes data",
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

extension EpisodesDataViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return EpisodesManager.episodesData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Season \(EpisodesManager.episodesData[section].season)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EpisodesManager.episodesData[section].episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
            let episode = EpisodesManager.episodesData[indexPath.section].episodes[indexPath.row]
            cell.textLabel?.text = "Episode \(episode.episode)"
            cell.detailTextLabel?.text = "\(episode.title)"
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension EpisodesDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            proceedToEpisodeDetailsView(season: indexPath.section, episodeIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configureHeader(view: view, fontSize: 20)
    }
}

// MARK: - EpisodeFilter Delegate Methods

extension EpisodesDataViewController: FilterEpisodesDelegate {
    
    func didApplyEpisodesFilter(
        seasons: [Int]?,
        fromDate: String?,
        toDate: String?,
        characters: [String]?)
    {
        EpisodesManager.filterEpisodesData(
            seasons: seasons,
            fromDate: fromDate,
            toDate: toDate,
            characters: characters
        )
        tableView.reloadData()
    }
}

// MARK: - Transitions

private extension EpisodesDataViewController {
    
    func proceedToFilterEpisodesView() {
        let filterEpisodesVC = FilterEpisodesViewController()
        filterEpisodesVC.modalPresentationStyle = .popover
        filterEpisodesVC.delegate = self
        present(filterEpisodesVC, animated: true)
    }
    
    func proceedToEpisodeDetailsView(season: Int, episodeIndex: Int) {
        if let episodeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as? EpisodeDetailViewController {
            episodeDetailVC.episode = EpisodesManager.episodesData[season].episodes[episodeIndex]
            self.present(episodeDetailVC, animated: true, completion: nil)
        }
    }
}
