//
//  CoreDataHelper.swift
//  BPI
//
//  Created by Greg Williams on 4/12/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    class func managedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    class func insertManagedObject (className:String, managedObjectContext:NSManagedObjectContext) -> AnyObject {
        let managedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext)
        
        return managedObject
    }
    
    class func fetchEntities (className:String, managedObjectContext:NSManagedObjectContext, predicate:NSPredicate?, sortDescriptor:NSSortDescriptor?, fetchLimit: Int?) -> NSArray {
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        if fetchLimit != nil {
            fetchRequest.fetchLimit = fetchLimit!
        }
        
        var items = []
        
        do {
            try items = managedObjectContext.executeFetchRequest(fetchRequest)
        }catch {
            print(error)
        }
        
        return items
        
    }
}