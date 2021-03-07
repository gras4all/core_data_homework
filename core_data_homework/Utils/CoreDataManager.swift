//
//  CoreDataManager.swift
//  CoreDataStack
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: CoreData Stack initialisation
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject> (from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let context = getContext()
        let request: NSFetchRequest<T>
        var fetchedResult = [T]()
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            let entityName = String(describing: entity)
            request = NSFetchRequest(entityName: entityName)
        }
        request.predicate = predicate
        do {
            fetchedResult = try context.fetch(request)
            
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        return fetchedResult
    }
        
}

