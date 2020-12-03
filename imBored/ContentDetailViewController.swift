//
//  ContentDetailViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/2/20.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    @IBOutlet var contentTitleLabel: UILabel!
    @IBOutlet var contentDateLabel: UILabel!
    @IBOutlet var contentLangLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    let servicesList: [String] = ["fuboTV","google_play","hulu","itunes","netflix","Philo","prime","vudu","youtube","pirate"]
    
    let servicesImages = [UIImage(named: "fuboTV"),UIImage(named: "google_play"),UIImage(named: "hulu"),UIImage(named: "itunes"),UIImage(named: "netflix"),UIImage(named: "Philo"),UIImage(named: "prime"),UIImage(named: "vudu"),UIImage(named: "youtube"),UIImage(named: "pirate")]
    
    var showData: TVData!
    var movieData: MovieData!
    
    var name: String = ""
    var date: String = ""
    var lang: String = ""
    var artwork: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateUserInterface()

        // Do any additional setup after loading the view.
    }
    
    
    
    func updateUserInterface(){
        if showData != nil{
            contentTitleLabel.text = showData.name
            contentDateLabel.text = showData.first_air_date
            contentLangLabel.text = showData.origin_country?.first
            textView.text = showData.overview
            let imageURLString = "https://image.tmdb.org/t/p/w185\(showData.poster_path ?? "")"
            contentImageView.imageFromURL(urlString: imageURLString)
        }
        if movieData != nil {
            contentTitleLabel.text = movieData.title
            contentDateLabel.text = movieData.release_date
            contentLangLabel.text = movieData.original_language
            textView.text = movieData.overview
            let imageURLString = "https://image.tmdb.org/t/p/w185\(movieData.poster_path ?? "")"
            contentImageView.imageFromURL(urlString: imageURLString)
        }
    }
    
}
extension ContentDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ServicesCollectionViewCell
            let image = servicesImages[indexPath.row]
            cell.imageView.image = image
            return cell
    }
    
    
}
