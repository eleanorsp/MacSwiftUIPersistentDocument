//
//  Document.swift
//  MacCoreDataDocument
//
//  Created by Eleanor Spenceley on 16/08/2020.
//  Copyright © 2020 Eleanor Spenceley. All rights reserved.
//

import Cocoa
import SwiftUI

class Document: NSPersistentDocument {

    var documentObject : DocumentObject?
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        
        let request: NSFetchRequest<DocumentObject> = DocumentObject.fetchRequest()
        do {
            let results = try self.managedObjectContext!.fetch(request)
            
            if results.count == 0 {
                if let savedDataEntity = NSEntityDescription.entity(forEntityName: "DocumentObject", in: self.managedObjectContext!),
                    let newSavedData = NSManagedObject(entity: savedDataEntity, insertInto: self.managedObjectContext!) as? DocumentObject {
                    
                    newSavedData.id = UUID()
                    self.documentObject = newSavedData
                    
                    Document.primeEmptyDocument(moc: self.managedObjectContext!, document: self.documentObject!)
                }
            }
            else {
                self.documentObject = results[0]
            }
        }
        catch {
            Swift.print("\(error)")
        }
        
        if self.documentObject == nil {
            return
        }
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.

        // Yes, there's a whole load of ! ... it's messy but this is test code.
        let contentView = ContentView(document: self.documentObject!).environment(\.managedObjectContext, self.managedObjectContext!)
         
        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = NSWindowController(window: window)
        
        if let contentVC = windowController.contentViewController  {
               
            // This is important by the looks of it....
            contentVC.representedObject = documentObject
        }
        
        self.addWindowController(windowController)
    }
    


    static func primeEmptyDocument(moc: NSManagedObjectContext, document: DocumentObject) {
        
        if let savedDataEntity = NSEntityDescription.entity(forEntityName: "TestObject", in: moc),
            let newSavedData = NSManagedObject(entity: savedDataEntity, insertInto: moc) as? TestObject {
            
            newSavedData.testString = "Primed Data"
            
            document.addToTests_rel(newSavedData)
            
            // Dont force a save since there might not be a file to save too?!?!?
//            do {
//                //              try moc.save()
//            }
//            catch let error {
//                Swift.print("\(error.localizedDescription)")
//            }
        }
    }
}
