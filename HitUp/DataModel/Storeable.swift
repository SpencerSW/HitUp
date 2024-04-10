//
//  Storeable.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/10/24.
//

import UIKit
import CoreData

class Storeable {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data: Array<NSManagedObject> = []
    
    init(of entityName: String, with predicate: NSPredicate? = nil) {
        loadData(of: entityName, with: predicate)
    }
    
    func addItem(_ item: NSManagedObject) {
        data.append(item)
        saveData()
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < data.count else {
            print("Index out of bounds")
            return
        }
        
        let itemToDelete = data[index]
        
        context.delete(itemToDelete)
        data.remove(at: index)
        
        saveData()
    }
    
    func saveData() {
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadData(of entityName: String, with predicate: NSPredicate? = nil) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            data = try context.fetch(request)
        } catch {
            print("Error fetching \(entityName) objects: \(error)")
        }
    }

    func updateModel(at indexPath: IndexPath) {
        removeItem(at: indexPath.row)
    }

    func fetchItems(withPredicate predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        guard let firstObject = data.first else {
            print("No objects available in data.")
            return nil
        }
        
        let entityName = String(describing: type(of: firstObject))
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        
        do {
            let fetchedItems = try context.fetch(request)
            return fetchedItems
        } catch {
            print("Error fetching items: \(error)")
            return nil
        }
    }
}
