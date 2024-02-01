//
//  DetailedPokemonViewController.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/29.
//

import UIKit
import SDWebImageSVGKitPlugin
import SVGKit

class DetailedPokemonViewController: UIViewController {
    var viewModel: PokemonDetailViewModel!
    var pokemonId: Int!
    var pokemonName: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var favSwitch: UISwitch!
    @IBAction func favouriteSwitchToggled(_ sender: UISwitch) {
        viewModel.updateFavouriteStatus(for: pokemonId, isFavourite: sender.isOn)
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!{
        didSet{
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .large
        }
    }
    
    
    
    init(pokemonId: Int, pokemonName: String) {
        self.pokemonId = pokemonId
        super.init(nibName: "DetailedPokemonViewController", bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        pokemonDataFetchStarted()
        viewModel = PokemonDetailViewModel(pokemonId: pokemonId)
        viewModel.delegate = self
        favSwitch.isOn = viewModel.isFavourite(pokemonId: pokemonId)
        super.viewDidLoad()
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension DetailedPokemonViewController : PokemonDetailedDataViewModelDelegate {
    func pokemonDataFetchFailed(with error: Error) {
        loadingIndicator.stopAnimating()
        showAlert(with: "Error", message: "Failed to fetch Pokemon data: \(error.localizedDescription)")
    }
    
    func pokemonDataFetchStarted() {
        loadingIndicator.startAnimating()
        
    }
    
    func pokemonDataFetched() {
        loadingIndicator.stopAnimating()
        weight.text = "Weight: \(viewModel.pokemon?.weight ?? 0 )"
        exp.text = "Base experience: \(viewModel.pokemon?.base_experience ?? 0 )"
        height.text = "Height: \(viewModel.pokemon?.height ?? 0 )"
        if let url = URL(string: viewModel.pokemon?.sprites.other.dream_world.front_default ?? "") {
            imageView.sd_setImage(with: url) { (image, error, cacheType, imageURL) in
                self.loadingIndicator.stopAnimating()
                if let error = error {
                    print(url)
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
    
    
}
