//
//  CoreDataManager.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 13.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
   lazy var context = self.persistentContainer.viewContext
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CFTModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func newNoteInStore(title: String, mainText: String, complition: @escaping(() -> Void)) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        let noteObject = Note(entity: entity, insertInto: context)
        noteObject.title = title
        noteObject.mainText = mainText
        do {
            try context.save()
            complition()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
    }
    
    func editNoteInStore(beforeTitle: String, title: String, mainText: String, complition: () -> Void) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for obj in objects {
                if beforeTitle == obj.title {
                    obj.title = title
                    obj.mainText = mainText
                }
            }
        }
        do {
            try context.save()
            complition()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getNotesFromStore(complition: ([Note]) -> Void) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let notes = try context.fetch(fetchRequest)
            complition(notes)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func removeNoteFromStore(indexPath: IndexPath, complition: () -> Void) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            context.delete(objects[indexPath.row])
        }
        do {
            try context.save()
            complition()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}


