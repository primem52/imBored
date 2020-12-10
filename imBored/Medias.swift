//
//  Spots.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/8/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class Medias{
    var mediaArray: [Media] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("media").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("Error \(error?.localizedDescription)")
                return completed()
            }
            self.mediaArray = []
            for document in querySnapshot!.documents {
                let media = Media(dictionary: document.data())
                media.documentID = document.documentID
                self.mediaArray.append(media)
            }
        }
    }
    
}
