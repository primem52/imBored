//
//  SearchResultViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/2/20.
//

import UIKit

class MovieSearchResultViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
  
    var movies = ResultData()
    let contentType = "1"
    var query: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        movies.getMovieData(query: query) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieDetail" {
            let destination = segue.destination as! ContentDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.movieData = movies.movieArray[selectedIndexPath.row]
            destination.contentType = contentType
            destination.docID = "\(movies.movieArray[selectedIndexPath.row].id)"
        }
    }
//    func getImage(urlString: String) -> UIImage{
//        let url = URL(string: urlString)
//        let data = try? Data(contentsOf: url!)
//
//        if let imageData = data {
//            let image = UIImage(data: imageData)
//            return image!
//        }
//        return UIImage()
//    }
    

}

extension MovieSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieTableViewCell
        cell.dateLabel.text = movies.movieArray[indexPath.row].release_date
        cell.titleLabel.text = movies.movieArray[indexPath.row].title
        cell.descriptionView.text = movies.movieArray[indexPath.row].overview
        cell.langLabel.text = movies.movieArray[indexPath.row].original_language
        let imageURLString = "https://image.tmdb.org/t/p/w185\(movies.movieArray[indexPath.row].poster_path ?? "")"
        print(imageURLString)
        cell.picImageView.imageFromURL(urlString: imageURLString)
        return cell
    }
    
    
}

