//
//  MovieCategory.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit

//MARK: - MovieCategory
struct MovieCategory
{
    var typeId: Int
    var title: String
    var entityName: String
    var sortBy: String
    var ascending: Bool
    
    init(typeId: Int, title: String, entityName: String, sortBy: String, ascending: Bool) {
        self.typeId = typeId
        self.title = title
        self.entityName = entityName
        self.sortBy = sortBy
        self.ascending = ascending
    }
}
