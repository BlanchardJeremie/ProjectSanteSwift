//
//  PatientTableViewController.swift
//  ProjectIOsSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class PatientTableViewController: UITableViewController {

    var patients = [PersonneData]()
    var fetchedResultController : NSFetchedResultsController<PersonneData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fetchRequest = NSFetchRequest<PersonneData>(entityName: "PersonneData")
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "PersonneData")
        
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView.reloadData()
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateViewController))
        
        //let buttonDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showCreateViewController))
        
        let buttonPreference = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showUserDefaultViewController))
        
        self.navigationItem.leftBarButtonItem = buttonPreference
        self.navigationItem.rightBarButtonItem = buttonAdd
        
        
              
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let fetchRequest = NSFetchRequest<PersonneData>(entityName: "PersonneData")
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        
        do{
         self.patients = try persistentContainer.viewContext.fetch(fetchRequest)
        }catch{
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultController.sections?.count ?? 0
        // return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)

        // Configure the cell...
      //  print(UserDefaults.standard.value(forKey: "LocationName"))
        
        
        if UserDefaults.standard.bool(forKey: "LocationName") == false{            
            cell.textLabel?.text = fetchedResultController.object(at: indexPath).afficherNomString() + " " + fetchedResultController.object(at: indexPath).afficherPrenomString()
        }else{
            cell.textLabel?.text = fetchedResultController.object(at: indexPath).afficherPrenomString() + " " +  fetchedResultController.object(at: indexPath).afficherNomString()
        }
        
        
        

        return cell
    }
    
    
    func showCreateViewController(){
        let controller = CreatePatientViewController(nibName: "CreatePatientViewController", bundle: nil)
        self.present(controller, animated: true, completion: nil)
       // controller.delegate.self
    }
    
    func showUserDefaultViewController(){
        let controller = UserDefaultViewControler(nibName: "UserDefaultViewControler", bundle: nil)
        self.present(controller, animated: true, completion: nil)
        // controller.delegate.self
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailController = segue.destination as? DetailViewController{
            guard let selectedIndexPath = tableView.indexPathForSelectedRow
        else{
            return
            }
            
            detailController.patient = patients[selectedIndexPath.row]
            detailController.onDelete = {
            let patient = self.fetchedResultController.object(at: selectedIndexPath)
                self.persistentContainer.viewContext.delete(patient)
                try? self.persistentContainer.viewContext.save()
                self.navigationController?.popViewController(animated: true)
            }
            self.tableView.reloadData()
            detailController.patient = fetchedResultController.object(at: selectedIndexPath)
        }
    }

}

extension PatientTableViewController: CreatePatientDelegate{
    
    func createPerson(personne: PersonneData) {
       patients.append(personne)
        tableView.reloadData()
        print(personne.afficherNomComplet())
        self.dismiss(animated: true, completion: nil)
    }
}

extension PatientTableViewController : NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}






