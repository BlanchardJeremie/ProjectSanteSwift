//
//  AppDelegate.swift
//  ProjectIOsSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataImport: Bool = false
    let apiPersonneUrl = "http://10.1.0.100:3000/persons"
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     //   print(persistentContainer.name)
        updateDataFromServer()
        importDataFromPlistIfNeeded()
        return true
    }
    
    
    func importDataFromPlistIfNeeded(){
        // check if import as been done
        //if false : import
        
        let fileUrl = Bundle.main.url(forResource: "names",withExtension: "plist")
        //  print(FileManager.default.fileExists(atPath: fileUrl!.absoluteString))
        
        
        guard let url = fileUrl ,let array = NSArray(contentsOfFile: url.path)else{
        return
        }
        
        let dataImport = UserDefaults.standard.value(forKey: "dataImportKey") as? Bool ?? false
        
        //   print(array)
        if !dataImport{
            //read Data
            for dict in array{
                if let dictionnary = dict as? [String:Any]{
                    let firstname = dictionnary["name"] as? String ?? "Error"
                    let lastname = dictionnary["lastname"] as? String ?? "Error"
                    let pictureUrl = dictionnary["pictureUrl"] as? String ?? "Error"
                    let data = PersonneData(entity: PersonneData.entity(), insertInto: persistentContainer.viewContext)
                    data.firstname = firstname
                    data.lastname = lastname
                    data.pictureUrl = pictureUrl
                    
                    
                 /*   if let isFemal = dictionnary["isfemale"] as? Bool , isFemal == true {
                        //  self.patients.append(Personne(prenom: fristname, nom: lastname, genre: .Male))
                    } else {
                        //    self.patients.append(Personne(prenom: fristname, nom: lastname, genre: .Male))
                    }*/
                }
            }
            
            do{
                try persistentContainer.viewContext.save()
            }catch{
                print(error)
            }
            
            
            UserDefaults.standard.set(true, forKey: "dataImportKey")
        }

    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // lazy
     var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
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
    
    func updateDataFromServer(){
    let url = URL(string: apiPersonneUrl)!
        let task = URLSession.shared.dataTask(with:url) { (data , response , error) in
            guard let data = data else{
            return
            }
            let dictionnary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let jsonDict = dictionnary as? [[String: Any]] else {
            return
            }
            print(String(describing: jsonDict))
            self.updateFromJsonData(json: jsonDict)
            
        }
        task.resume()
        
    }
    
    func updateFromJsonData(json : [[String: Any]]){
        
        
        

        
        let fetchRequest = NSFetchRequest<PersonneData>(entityName: "PersonneData")
        let sort = NSSortDescriptor(key: "jsonName", ascending: true)
        /*fetchRequest.sortDescriptors = [sort]
        /do{
            self.patients = try persistentContainer.viewContext.fetch(fetchRequest)
        }catch{
            print(error)
        }*/
        
        //delete all
        let persons = try! persistentContainer.viewContext.fetch(fetchRequest)
        for patient in persons{
        persistentContainer.viewContext.delete(patient)
        }
        try! persistentContainer.viewContext.save()
        //fin delete
        for dict in json{
            if let dictionnary = dict as? [String:Any]{
                let firstname = dictionnary["surname"] as? String ?? "Error"
                let lastname = dictionnary["lastname"] as? String ?? "Error"
                let pictureUrl = dictionnary["pictureUrl"] as? String ?? "Error"
                let data = PersonneData(entity: PersonneData.entity(), insertInto: persistentContainer.viewContext)
                data.firstname = firstname
                data.lastname = lastname
                data.pictureUrl = pictureUrl
            }
            
            do{
                try persistentContainer.viewContext.save()
            }catch{
                print(error)
            }
        }
     
    }
}


extension UIViewController{

    var persistentContainer : NSPersistentContainer{
        get {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            return appdelegate.persistentContainer
        }
        
        
    }

}

