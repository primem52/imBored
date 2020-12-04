//
//  SearchResultViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/2/20.
//

import UIKit

class TVSearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var shows = ResultData()
    let contentType = "TV"
    var query: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        shows.getTVData(query: query){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVDetail" {
            let destination = segue.destination as! ContentDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.showData = shows.tvArray[selectedIndexPath.row]
            destination.contentType = contentType
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

extension TVSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.tvArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TVTableViewCell
        cell.dateLabel.text = shows.tvArray[indexPath.row].first_air_date
        cell.titleLabel.text = shows.tvArray[indexPath.row].name
        cell.descriptionTextView.text = shows.tvArray[indexPath.row].overview
        cell.langLabel.text = shows.tvArray[indexPath.row].origin_country?.first ?? ""
        let imageURLString = "https://image.tmdb.org/t/p/w185\(shows.tvArray[indexPath.row].poster_path ?? "")"
        cell.picImageView.imageFromURL(urlString: imageURLString)
        return cell
    }
}


