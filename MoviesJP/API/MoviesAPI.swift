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
    
    func loadPopular(completion: @escaping MoviesPopularHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/popular", method: .get, parameters: _parameters).responsePopular { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadTopRated(completion: @escaping MoviesTopRatedHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        
        Alamofire.request("\(Env.MoviesApi.basePath)/movie/popular", method: .get, parameters: _parameters).responseTopRated { (response) in
            if let response = response.result.value {
                completion(response, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadUpcoming(completion: @escaping MoviesUpcomingHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = Env.MoviesApi.ApiKey
        
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
}

extension DataRequest {
    @discardableResult
    func responsePopular(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<PopularResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    func responseTopRated(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<TopRatedResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    func responseUpcoming(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UpcomingResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    func responseVideos(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MovieVideoResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
