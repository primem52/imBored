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
    
    var showData: TVData!
    var movieData: MovieData!
    
    
    var selectedService: String = ""
    var artwork: UIImage = UIImage()
    var dateToChange: Date = Date()
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedServiceLabel: UILabel!
    
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let servicesList: [String] = ["fuboTV","google_play","hulu","itunes","netflix","Philo","prime","vudu","youtube","pirate"]
    
    let servicesImages = [UIImage(named: "fuboTV"),UIImage(named: "google_play"),UIImage(named: "hulu"),UIImage(named: "itunes"),UIImage(named: "netflix"),UIImage(named: "Philo"),UIImage(named: "prime"),UIImage(named: "vudu"),UIImage(named: "youtube"),UIImage(named: "pirate")]
    
    
    
    override func viewDidLoad() {
        //get from struct
        selectedServiceLabel.text = ""
        saveBarButton.tintColor = .systemRed
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        datePicker.maximumDate = Date()
        imageView.image = artwork
        commentView.text = ""
        collectionView.delegate = self
        collectionView.dataSource = self
        guard media != nil else{
            print("No media passed")
            return
        }
        if review == nil {
            review = Review()
        }
        formatLabels()
    }
    
    func checkIfCompleted() -> Bool{
        if !commentView.text.isEmpty && selectedServiceLabel.text != "" {
            saveBarButton.tintColor = .systemGreen
            return true
        }
        return false
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
        if checkIfCompleted(){
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
        else{
            var name: String = ""
            if showData != nil{
                name = showData.name!
            }
            if movieData != nil{
                name = movieData.title!
            }
            oneButtonAlert(title: "Nope you can't save yet...", message: "Please tell us where you watched \(name), when you watched it, and leave some thoughts!")
        }
        
    }
    func formatLabels(){
        if showData != nil{
            commentTitleLabel.text = "Have anything to say about \(showData.name!)?"
            dateTitleLabel.text = "When did you watch \(showData.name!)?"
            serviceTitleLabel.text = "Where did you watch \(showData.name!)?"
        }
        if movieData != nil{
            commentTitleLabel.text = "Have anything to say about \(movieData.title!)?"
            dateTitleLabel.text = "When did you watch \(movieData.title!)?"
            serviceTitleLabel.text = "Where did you watch \(movieData.title!)?"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.leaveViewController()
    }
    
    func updateFromUserInterface(){
        review.date = dateToChange
        review.service = selectedService
        review.comment = commentView.text ?? ""
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateToChange = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let somedateString = dateFormatter.string(from: sender.date)
        print(somedateString)  // "somedateString" is your string date
        let _ = checkIfCompleted()
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
        selectedService = servicesList[indexPath.row]
        let _ = checkIfCompleted()
    }
    
    
}

