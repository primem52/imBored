//
//  Media.swift
//  imBored
//
//  Created by Morgan Prime on 12/9/20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Media{
    var name: String
    var mediaType: String
    var postingUserID: String
    var documentID: String
    //var contentID: String
    
    var dictionary: [String: Any]{
        return ["name": name, "mediaType": mediaType, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(name: String, mediaType: String, postingUserID: String, documentID: String){
        self.name = name
        self.mediaType = mediaType
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    convenience init(){
        self.init(name: "", mediaType: "" ,  postingUserID: "", documentID: "")
    }
    
//    convenience init(dictionary: [String: Any]){
//        let name = dictionary["name"] as! String? ?? ""
//        let mediaType = dictionary["mediaType"] as! String? ?? ""
//        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
//        let documentID = dictionary["documentID"] as! String? ?? ""
//        self.init(name: name, mediaType: mediaType, postingUserID: postingUserID, documentID: documentID)
//    }
    
    func saveData(completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //grab user id
        guard let postingUserID = Auth.auth().currentUser?.uid else{
            print("error")
            return completion(false)
        }
        self.postingUserID = postingUserID
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == ""{
            var ref: DocumentReference? = nil
            ref = db.collection("media").addDocument(data: dataToSave){ (error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)") // it worked
                completion(true)
            }
        }
        else{
            let ref = db.collection("media").document(self.documentID)
            ref.setData(dataToSave) {(error) in
                guard error == nil else{
                    print("Error: \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Added document: \(self.documentID)")
                completion(true)
            }
        }
    }
    
    
}
