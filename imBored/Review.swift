//
//  Review.swift
//  imBored
//
//  Created by Morgan Prime on 12/9/20.
//

import Foundation
import Firebase

class Review {
    var service: String
    var reviewUserID: String
    var reviewUserEmail: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any]{
        let timeIntervalDate = date.timeIntervalSince1970
        return["service":service,"reviewUserID":reviewUserID,"reviewUserEmail":reviewUserEmail, "date": timeIntervalDate]
    }
    
    init( service:String, reviewUserID: String, reviewUserEmail: String, date:Date, documentID:String){
        self.service = service
        self.reviewUserID = reviewUserID
        self.reviewUserEmail = reviewUserEmail
        self.date = date
        self.documentID = documentID
    }
    
    convenience init(){
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        let reviewUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(service:"", reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, date:Date(), documentID:"")
    }
    
    convenience init(dictionary: [String: Any]){
        let service = dictionary["service"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let reviewUserEmail = dictionary["reviewUserEmail"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        
        self.init(service:service, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, date: date, documentID: documentID)
    }
    
    func saveData(media: Media, completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //grab user id
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == ""{
            var ref: DocumentReference? = nil
            ref = db.collection("media").document(media.documentID).collection("reviews").addDocument(data: dataToSave){ (error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID) to media \(media.documentID)") // it worked
                completion(true)
            }
        }
        else{
            let ref = db.collection("media").document(media.documentID).collection("reviews").document((self.documentID))
            ref.setData(dataToSave) {(error) in
                guard error == nil else{
                    print("Error: \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Added document: \(self.documentID) in spot \(media.documentID)")
                completion(true)
            }
        }
    }
    func deleteData(media: Media, completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        db.collection("media").document(media.documentID).collection("reviews").document(documentID).delete { (error) in
            if let error = error {
                print("Error deleting:\(self.documentID)")
                print("Error:\(error.localizedDescription)")
                completion(false)
            }
            else{
                print("successfully deleted document: \(self.documentID)")
                completion(true)
            }
        }
    }
}
