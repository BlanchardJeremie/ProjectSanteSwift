//
//  UserDefaultViewControler.swift
//  ProjectIOsSante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserDefaultViewControler: UIViewController {
    @IBOutlet weak var segmentedName: UISegmentedControl!

    @IBOutlet weak var buttonDenied: UIButton!
    @IBOutlet weak var buttonAccepted: UIButton!
    
    
    let preferenceKey: String = "LocationName"
    var preference = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(preference, forKey: preferenceKey)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func acceptedchangename(_ sender: Any) {
        if(self.segmentedName.selectedSegmentIndex == 0){
            preference = false
           UserDefaults.standard.set(preference, forKey: preferenceKey)
        }else{
            preference = true
         UserDefaults.standard.set(preference, forKey: preferenceKey)
        }
        self.dismiss(animated: true, completion: nil)

        
        
    }

    
     @IBAction func actionDenied(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
