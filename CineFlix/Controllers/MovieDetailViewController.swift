//
//  MovieDetailViewController.swift
//  CineFlix
//
//  Created by Rajat Sachdeva on 2024-12-07.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        guard let movie = movie else { return }
        titleLabel.text = movie.displayTitle
        releaseDateLabel.text = "\(movie.release_date ?? "N/A")"
        ratingLabel.text = "\(movie.vote_average ?? 0)/10"
        descriptionLabel.text = movie.overview

        if let posterPath = movie.poster_path {
            let imageUrl = "\(APIConstants.imageBaseURL)\(posterPath)"
            loadImage(from: imageUrl)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
            guard let movie = movie else { return }
            
            // Save the movie to Core Data
            CoreDataManager.shared.saveMovie(movie)
            
            // Provide user feedback (e.g., show an alert or update the button)
            let alert = UIAlertController(title: "Favourited", message: "Movie has been added to your favourites!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
}
