//
//  MoviesAPI.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import Alamofire

class MoviesAPI {
    typealias MoviesPopularHandler = (PopularResponse?, Error?) -> Void
    typealias MoviesTopRatedHandler = (TopRatedResponse?, Error?) -> Void
    typealias MoviesUpcomingHandler = (UpcomingResponse?, Error?) -> Void
    typealias MovieVideoHandler = (MovieVideoResponse?, Error?) -> Void
    typealias MovieSearchHandler = (MovieSearchResponse?, Error?) -> Void
    
    func loadPopular(page: Int, completion: @escaping MoviesPopularHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        _parameters["page"] = page
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/popular", method: .get, parameters: _parameters).responsePopular { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadTopRated(page: Int, completion: @escaping MoviesTopRatedHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        _parameters["page"] = page
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/popular", method: .get, parameters: _parameters).responseTopRated { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadUpcoming(page: Int, completion: @escaping MoviesUpcomingHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        _parameters["page"] = page
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/popular", method: .get, parameters: _parameters).responseUpcoming { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadVideos(movieId: Int, completion: @escaping MovieVideoHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/\(movieId)/videos", method: .get, parameters: _parameters).responseVideos { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func searchMovieBy(query: String, completion: @escaping MovieSearchHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        _parameters["query"] = query
        
        Alamofire.request("\(Env.MoviesApi.basePath)/search/movie", method: .get, parameters: _parameters).responseSearch { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
}
