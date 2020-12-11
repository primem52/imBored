//
//  Reviews.swift
//  imBored
//
//  Created by Morgan Prime on 12/9/20.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var tempArray: [Review] = []

    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(media: Media, completed: @escaping () -> ()){
        guard media.documentID != "" else{
            return
        }
        db.collection("media").document(media.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("Error \(error?.localizedDescription ?? "Some random error")")
                return completed()
            }
            self.reviewArray = [] // clean out existing reviewarray since new data will load
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }

    }
    
}
