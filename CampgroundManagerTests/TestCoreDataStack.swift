//
//  TestCoreDataStack.swift
//  CampgroundManager
//
//  Created by Hai Vo L. on 11/17/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CampgroundManager
import CoreData

class TestCoreDataStack: CoreDataStack {

  convenience init() {
    self.init(modelName: "CamgroundManager")
  }

  override init(modelName: String) {
    super.init(modelName: modelName)

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentContainer(name: modelName)
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as? NSError {
        fatalError("Unresolved error \(error) ,Description \(error.userInfo)")
      }
    }
    self.storeContainer = container
  }
}
