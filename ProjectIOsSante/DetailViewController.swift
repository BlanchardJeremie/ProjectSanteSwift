//
//  DetailViewController.swift
//  ProjectIOsSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var patient: PersonneData!
    var onDelete: (() -> ())?
    @IBOutlet weak var lastenameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = patient.afficherNomComplet()
        lastenameLabel.text = patient.afficherNomString()
        nameLabel.text = patient.afficherPrenomString()
        // Do any additional setup after loading the view.
        
        avatarImage.image = UIImage(named: "")

        let task = URLSession.shared.dataTask(with: URL(string :patient.pictureUrl!)!) { (data , response , error) in
            
            print(Thread.isMainThread)
            if let data = data, let image = UIImage(data: data){
                self.avatarImage.image = image
            }
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let buttonDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeletePersonne))
        
        self.navigationItem.rightBarButtonItem = buttonDelete

    }
    
    func onDeletePersonne(){      
        onDelete!()

    }
    
    

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
