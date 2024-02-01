//
//  ViewController.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/27.
//

import UIKit
class ViewController: UITableViewController {
    private var viewModel: PokemonListViewModel!
    private var pokemons: [PokemonList] = []
    private var tasks: [URL: URLSessionDataTask] = [:]
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet{
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .large
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PokemonListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PokemonListTableViewCell")
        tableView.rowHeight = 80.0
        
        configureSearchBar()
        
        viewModel = PokemonListViewModel()
        viewModel.delegate = self
        viewModel.fetchPokemons()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListTableViewCell", for: indexPath) as? PokemonListTableViewCell else {
            fatalError("Unable to dequeue PokemonListTableViewCell")
        }
        let pokemon = pokemons[indexPath.row]
        cell.pokemonName.text = pokemon.name
        cell.pokemonImage.image = nil
        loadImage(for: pokemon, into: cell)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonId = pokemons[indexPath.row].id
        let pokemonName = pokemons[indexPath.row].name
        let detailedVC = DetailedPokemonViewController(pokemonId: pokemonId, pokemonName:pokemonName )
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    
    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Favourites"]
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = true
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadImage(for pokemon: PokemonList, into cell: PokemonListTableViewCell) {
        if let oldTask = tasks[pokemon.imageUrl] {
            oldTask.cancel()
        }
        
        viewModel.fetchImageData(from: pokemon.imageUrl) { [weak self] (result: Result<UIImage, Error>) in
            switch result {
            case .success(let image):
                if cell.pokemonName.text == pokemon.name {
                    cell.pokemonImage.image = image
                }
            case .failure(let error):
                self?.pokemonDataFetchFailed(with: error)
            }
        }
    }
}


extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            viewModel.fetchPokemons()
        } else {
            viewModel.fetchPokemons(with: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: navigationItem.searchController!)
    }
}

extension ViewController: PokemonDataViewModelDelegate {
    func pokemonDataFetched(pokemons: [PokemonList]) {
        self.loadingIndicator.stopAnimating()
        self.pokemons = pokemons
        
        if let scope = self.navigationItem.searchController?.searchBar.selectedScopeButtonIndex, scope == 1 {
            let favouritePokemons = UserDefaults.standard.dictionary(forKey: "FavouritePokemons") as? [String: Bool] ?? [:]
            self.pokemons = self.pokemons.filter { favouritePokemons[String($0.id)] == true }
        }
        
        self.tableView.reloadData()
        
    }
    
    func pokemonDataFetchFailed(with error: Error) {
        self.loadingIndicator.stopAnimating()
        showAlert(with: "Error", message: "Failed to fetch Pokemon data: \(error.localizedDescription)")
    }
    
    func pokemonDataFetchStarted() {
        self.loadingIndicator.startAnimating()
    }
    
    
}
