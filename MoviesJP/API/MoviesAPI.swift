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
    typealias MoviesTopRatedHandler = (TopRatedResponse?, Error?) -> Void
    
    func loadPopular(completion: @escaping MoviesTopRatedHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = "972bf0e30a7fadee6e66c29eb4a9f17d"
        
        Alamofire.request(Env.MoviesApi.popular, method: .get, parameters: _parameters).responseTopRated { (response) in
            if let topRated = response.result.value {
                completion(topRated, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadTopRated(completion: @escaping MoviesTopRatedHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = "972bf0e30a7fadee6e66c29eb4a9f17d"
        
        Alamofire.request(Env.MoviesApi.topRated, method: .get, parameters: _parameters).responseTopRated { (response) in
            if let topRated = response.result.value {
                completion(topRated, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func loadUpcoming(completion: @escaping MoviesTopRatedHandler) {
        
        var _parameters = [String : Any]()
        _parameters["api_key"] = "972bf0e30a7fadee6e66c29eb4a9f17d"
        
        Alamofire.request(Env.MoviesApi.upcoming, method: .get, parameters: _parameters).responseTopRated { (response) in
            if let topRated = response.result.value {
                completion(topRated, nil)
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
}
