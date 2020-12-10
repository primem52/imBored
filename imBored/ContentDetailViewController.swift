//
//  ContentDetailViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/2/20.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class ContentDetailViewController: UIViewController {
    
    @IBOutlet var contentTitleLabel: UILabel!
    @IBOutlet var contentDateLabel: UILabel!
    @IBOutlet var contentLangLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedServiceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var docID = ""
    
    let servicesList: [String] = ["fuboTV","google_play","hulu","itunes","netflix","Philo","prime","vudu","youtube","pirate"]
    
    let servicesImages = [UIImage(named: "fuboTV"),UIImage(named: "google_play"),UIImage(named: "hulu"),UIImage(named: "itunes"),UIImage(named: "netflix"),UIImage(named: "Philo"),UIImage(named: "prime"),UIImage(named: "vudu"),UIImage(named: "youtube"),UIImage(named: "pirate")]
    
    var showData: TVData!
    var movieData: MovieData!
    var media: Media!
    var reviews: Reviews!
    var contentType: String = ""
    
    var name: String = ""
    var date: String = ""
    var lang: String = ""
    var artwork: UIImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if media == nil {
            media = Media()
        }
        media.documentID = docID
        media.name = name
        media.mediaType = contentType
        
        updateFromInterface()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        selectedServiceLabel.isHidden = true
     
        reviews = Reviews()
        updateUserInterface()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if media.documentID != "" {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }

        reviews.loadData(media: media) {
            self.tableView.reloadData()
            self.reviewCountLabel.text = "\(self.reviews.reviewArray.count) peopleBored"
            
        }
      

   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateUserInterface()
        switch segue.identifier ?? "" {
        case "AddReview":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! ReviewViewController
            destination.media = media
            destination.artwork = artwork
        case "ShowReview":
            let destination = segue.destination as! ViewReviewViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.review = reviews.reviewArray[selectedIndexPath.row]
            destination.media = media
            destination.artwork = artwork
        default:
            print("couldnt find case for \(segue.identifier)")
        }
    }
   
    
    
    
    @IBAction func addReviewButtonPressed(_ sender: UIBarButtonItem) {
        if media.documentID == "" {
            print("This content has not been saved, Must save first")
        }
        else{
            performSegue(withIdentifier: "AddReview", sender: nil)
        }
    }
    
    func updateFromInterface(){
        media.saveData { (success) in
            if !success{
                self.oneButtonAlert(title: "save failed", message: "wouldnt save to cloud")
            }
        }
    }
    
    
    
    
    func updateUserInterface(){
        if showData != nil{
            contentTitleLabel.text = showData.name
            contentDateLabel.text = showData.first_air_date
            contentLangLabel.text = showData.origin_country?.first
            textView.text = showData.overview
            let imageURLString = "https://image.tmdb.org/t/p/w185\(showData.poster_path ?? "")"
            contentImageView.imageFromURL(urlString: imageURLString)
            artwork = contentImageView.image ?? UIImage()
        }
        if movieData != nil {
            contentTitleLabel.text = movieData.title
            contentDateLabel.text = movieData.release_date
            contentLangLabel.text = movieData.original_language
            textView.text = movieData.overview
            let imageURLString = "https://image.tmdb.org/t/p/w185\(movieData.poster_path ?? "")"
            contentImageView.imageFromURL(urlString: imageURLString)
            artwork = contentImageView.image ?? UIImage()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedServiceLabel.isHidden = false
        selectedServiceLabel.text = servicesList[indexPath.row].capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    
}

extension ContentDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReviewListTableViewCell
        cell.nameLabel.text = "\(reviews.reviewArray[indexPath.row].reviewUserEmail)"
        cell.dateLabel.text = "\(dateFormatter.string(from: reviews.reviewArray[indexPath.row].date))"
        return cell
    }
    
    
}
