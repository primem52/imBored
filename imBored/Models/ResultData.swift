//
//  CoronaData.swift
//  PocketFauci
//
//  Created by Morgan Prime on 11/23/20.
//

import Foundation

class ResultData {
    
    var pageNumber = 1
    var tvArray: [TVData] = []
    var movieArray: [MovieData] = []
    var continueLoading = true
    
    func resetPageNumber(){
        pageNumber = 0
    }
    
    func getTVData(query: String, completed: @escaping () -> ()){
        let toSearch = query.replacingOccurrences(of: " ", with: "%20")
        //create url
        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=edc3f134ca7ac723ef4375073618cd19&query=\(toSearch)&page=\(pageNumber)"
        guard let url = URL(string: urlString) else{
            print("Error: couldnt create url from \(urlString)")
            return
        }
        //Create a session
        let session = URLSession.shared
        
        //get data with datatask
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error { // if error not nil
                print("Error: \(error.localizedDescription)")
            }
            //deal with data
            do{
                let results = try JSONDecoder().decode(ShowResults.self, from: data!)
                let res = results.results
                if res.count > 0 {
                    self.pageNumber = self.pageNumber + 1
                    self.tvArray = self.tvArray + res
                }
                else {
                    self.continueLoading = false
                }
            }
            catch{
                print("Json Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    func getMovieData(query: String, completed: @escaping () -> ()){ // add to tseng
        //create url
        let toSearch = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=edc3f134ca7ac723ef4375073618cd19&query=\(toSearch)&page=\(pageNumber)"
        print(urlString)
        guard let url = URL(string: urlString) else{
            print("Error: couldnt create url from \(urlString)")
            return
        }
        //Create a session
        let session = URLSession.shared
        
        //get data with datatask
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error { // if error not nil
                print("Error: \(error.localizedDescription)")
            }
            //deal with data
            do{
                let results = try JSONDecoder().decode(MovieResults.self, from: data!)
                let res = results.results
                if res.count > 0 {
                    self.pageNumber = self.pageNumber + 1
                    self.movieArray = self.movieArray + res
                }
                else {
                    self.continueLoading = false
                }
            }
            catch{
                print("Json Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
