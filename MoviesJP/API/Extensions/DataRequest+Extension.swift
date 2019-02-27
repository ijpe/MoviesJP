//
//  DataRequest+Extension.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    @discardableResult
    func responsePopular(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<PopularResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseTopRated(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<TopRatedResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseUpcoming(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UpcomingResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseVideos(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MovieVideoResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSearch(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MovieSearchResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
