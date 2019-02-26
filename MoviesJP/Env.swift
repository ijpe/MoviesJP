//
//  Env.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

struct Env {
    struct MoviesApi {
        static var host: String {
            return "https://api.themoviedb.org"
        }
        static var basePath: String {
            return "\(host)/3"
        }
        static var popular: String {
            return "\(basePath)/movie/popular"
        }
        static var topRated: String {
            return "\(basePath)/movie/top_rated"
        }
        static var upcoming: String {
            return "\(basePath)/movie/upcoming"
        }
    }
}
