//
//  Result+CoreDataProperties.swift
//  DiceRoll
//
//  Created by DeNNiO   G on 24.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? "?"
    }
    @NSManaged public var score: Int16
    @NSManaged public var type: Int16

}
