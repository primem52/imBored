//
//  ReviewViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/9/20.
//

import UIKit

class ReviewViewController: UIViewController {
    var review: Review!
    var media: Media!
    var dateToChange: Date = Date()
    @IBOutlet weak var testDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedServiceLabel: UILabel!
    
 
    let servicesList: [String] = ["fuboTV","google_play","hulu","itunes","netflix","Philo","prime","vudu","youtube","pirate"]
    
    let servicesImages = [UIImage(named: "fuboTV"),UIImage(named: "google_play"),UIImage(named: "hulu"),UIImage(named: "itunes"),UIImage(named: "netflix"),UIImage(named: "Philo"),UIImage(named: "prime"),UIImage(named: "vudu"),UIImage(named: "youtube"),UIImage(named: "pirate")]
    
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        guard media != nil else{
            print("No media passed")
            return
        }
        if review == nil {
            review = Review()
        }
        
    }
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        review.saveData(media: media) { (success) in
            if success{
                self.leaveViewController()
            }
            else{
                print("Cant unwind from review")
            }
        }
    }
    func updateFromUserInterface(){
        review.date = dateToChange
        review.service = selectedServiceLabel.text!
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateToChange = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let somedateString = dateFormatter.string(from: sender.date)

        print(somedateString)  // "somedateString" is your string date
        
    }
    
}
extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

