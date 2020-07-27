//
//  CoreDataManager.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/24.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    var lovePhotos = [FavoritePhoto]()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "SearchTest")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addNewPhoto(title: String, data: Data) -> Bool {
        let managedContext = CoreDataManager.instance.persistentContainer.viewContext
        let photo = FavoritePhoto(context: managedContext)
        
        // Set attributes
        photo.setValue(title, forKey: "title")
        photo.setValue(data, forKey: "image")
        
        // commit changes and save to disk
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchPhoto() {
        let managedContext = CoreDataManager.instance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoritePhoto> = FavoritePhoto.fetchRequest()
        
        do {
            lovePhotos = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
