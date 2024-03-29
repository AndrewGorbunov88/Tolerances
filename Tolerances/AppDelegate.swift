//
//  AppDelegate.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 08.04.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let colorScheme = ColorSchemes()

//цвета в RGB: 1) 231 228 220 2) 170 158 148 3) 191 169 150 4) 155 144 135 5) 137 135 125

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let context = self.persistentContainer.viewContext
        let linearRequest = NSFetchRequest<MemoryTolerance>(entityName: "MemoryTolerance")
        
        do {
            var tolerancesArray = try context.fetch(linearRequest)
            if tolerancesArray.isEmpty {
                tolerancesArray.append(contentsOf: [createLinearEntity()])
                try context.save()
            }
        } catch {
            print("Error")
        }
        
        let fitRequest = NSFetchRequest<MemoryFitTolerance>(entityName: "MemoryFitTolerance")
        
        do {
            var fitTolerancesArray = try context.fetch(fitRequest)
            if fitTolerancesArray.isEmpty {
                fitTolerancesArray.append(contentsOf: [createFitEntity()])
                try context.save()
            }
        } catch {
            print("Error")
        }
        
        AppDelegate.colorScheme.createColorModel()
        
        return true
    }
    
    // MARK: - Methods
    
    func getFromContext() {
        
    }
    
    func createLinearEntity() -> MemoryTolerance {
        let memoryTolerance = MemoryTolerance(context: self.persistentContainer.viewContext)
        memoryTolerance.tolerance = ChosenTolerance.it12.rawValue
        
        memoryTolerance.holeField = HoleFields.h.rawValue
        memoryTolerance.holeState = 0
        
        memoryTolerance.shaftField = ShaftFields.h.rawValue
        memoryTolerance.shaftState = 0
        
        return memoryTolerance
    }
    
    func createFitEntity() -> MemoryFitTolerance {
        let fitMemoryTolerance = MemoryFitTolerance(context: self.persistentContainer.viewContext)
        fitMemoryTolerance.fitHoleField = HoleFields.h.rawValue
        fitMemoryTolerance.fitHoleState = 7
        
        fitMemoryTolerance.fitShaftField = ShaftFields.g.rawValue
        fitMemoryTolerance.fitShaftState = 2
        
        return fitMemoryTolerance
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tolerances CoreData Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

