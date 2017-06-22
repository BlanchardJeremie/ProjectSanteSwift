//
//  CreatePatientViewController.swift
//  ProjectIOsSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol CreatePatientDelegate: AnyObject  {
    func createPerson(personne: PersonneData)
}



class CreatePatientViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var personne : Personne!
    weak var delegate: CreatePatientDelegate?
    
    @IBOutlet weak var fieldSurname: UITextField!
    @IBOutlet weak var fieldLastname: UITextField!
    @IBOutlet weak var SelectGenre: UISegmentedControl!
    @IBOutlet weak var buttonadd: UIButton!
    @IBOutlet weak var progressbarcreateview: UIProgressView!
    var inprogress:Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // texteview.delegate.self
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func buttonadd(_ sender: Any) {
        
        
        DispatchQueue.global(qos: .userInitiated).async{
            
            for _ in 0...100{
                Thread.sleep(forTimeInterval: 0.01)
                DispatchQueue.main.async {
                    self.inprogress += 0.05
                    self.progressbarcreateview.setProgress(self.inprogress, animated: true)
                    
                    
                }
                
            }
            
            /*  if(self.progressbarcreateview.progress <= 1.0){
             
             
             let personne = PersonneData(entity: PersonneData.entity(), insertInto: self.persistentContainer.viewContext)
             personne.lastname = self.fieldLastname.text
             personne.firstname = self.fieldSurname.text
             do{
             try self.persistentContainer.viewContext.save()
             }catch{
             print(error)
             }      */
            
            
            
        }
        
        var json = [String:String]()
        json["lastname"] = self.fieldLastname.text ?? "Unknown"
        json["surname"] = self.fieldSurname.text ?? "Unknown"
        //json["pictureUrl"] = "https://s-media-cache-ak0.pinimg.com/236x/cf/e1/21/cfe121c41e3be479a08101057b171912.jpg"
        json["pictureUrl"] = "https://media.licdn.com/mpr/mpr/shrinknp_100_100/AAEAAQAAAAAAAAwgAAAAJGM2Nzk3ZmU5LTBiNWUtNDg2MS1iYjcxLWZjZWY1NGI5MTE1ZA.jpg"
        
        var request = URLRequest(url: URL(string: "http://10.1.0.100:3000/persons")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                guard let dict = jsonDict as? [String : Any] else {
                    return
                }
                
                //let person = Person(entity: Person.entity(), insertInto: self.managedObjectContext)
                let person = PersonneData(entity: PersonneData.entity(), insertInto: self.persistentContainer.viewContext)
                person.lastname = dict["lastname"] as? String
                person.firstname = dict["surname"] as? String
                person.pictureUrl = dict["pictureUrl"] as? String
                
                DispatchQueue.main.async{
                    do{
                        try self.persistentContainer.viewContext.save()
                    }catch{
                        print(error)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.createPerson(personne: person)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
}
