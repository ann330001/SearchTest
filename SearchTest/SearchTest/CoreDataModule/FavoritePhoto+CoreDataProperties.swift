//
//  FavoritePhoto+CoreDataProperties.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/24.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePhoto> {
        return NSFetchRequest<FavoritePhoto>(entityName: "FavoritePhoto")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: Data?

}
