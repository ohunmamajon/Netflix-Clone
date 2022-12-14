//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/14.
//
import Foundation

enum APIERROR: Error{
    case failedToGetData
}

struct Constants {
    static let API_KEY = "44e066c3385c3a960a566e0f14e38332"
    static let baseURL = "https://api.themoviedb.org"
}



class APICaller {
    static let shared = APICaller()
    
    
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void ){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            guard let data = data, error == nil else {return}
            
            do
            {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
