//
//  MovieCategory.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit

struct MovieCategory
{
    var typeId: Int
    var title: String
    var entityName: String
    
    init(typeId: Int, title: String, entityName: String) {
        self.typeId = typeId
        self.title = title
        self.entityName = entityName
    }
}
