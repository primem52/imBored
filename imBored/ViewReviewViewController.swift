//
//  ViewReviewViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/10/20.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class ViewReviewViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var commentView: UITextView!
    var artwork: UIImage = UIImage()
    var media: Media!
    var review: Review!

    override func viewDidLoad() {
        
 
        super.viewDidLoad()

        imageView.image = artwork
        nameLabel.text = review.reviewUserEmail
        dateLabel.text = "\(dateFormatter.string(from: review.date))"
        serviceLabel.text = review.service
        print(review.comment)
        commentView.text = review.comment
    }
    

}
