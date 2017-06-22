//
//  Personne.swift
//  ProjectIOsSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation



    extension PersonneData{
        
        func afficherNomString() -> String{
            return lastname!
        }
        
        func afficherPrenomString() -> String{
            return firstname!
        }
        func afficherNomComplet() -> String{
            if  isfemale {
                return "Mme. \(lastname!) \(firstname!)"
            }else{
                return "M. \(lastname!) \(firstname!)"
            }
        }


    }

class Personne {
    let prenom: String
    var nom: String
    // var nomcomplet: String
    // let nomcomplet = "\(nom)" + "\(prenom)"
    var pere: Personne?
    var mere: Personne?
    var enfants : [Personne]
    
    let genre: Gender
    
    init(prenom: String, nom: String,genre:Gender) {
        self.nom = nom
        self.prenom = prenom
        self.enfants = [Personne]()
        self.genre = genre
    }
    
    func afficherNomString() -> String{
        return nom
    }
    
    func afficherPrenomString() -> String{
        return prenom
    }
    
    func afficherNom(){
        print(nom)
    }
    
    func afficherNomComplet() -> String{
        if  genre == Gender.Female {
            return "Mme. \(nom)  \(prenom)"
        }else{
            return "M. \(nom)  \(prenom)"
        }
    }
    
    func afficherenfant(){
        for enfant in enfants{
            enfant.afficherNom()
            print(enfant.afficherNomComplet())
        }
    }
    
    func afficherNomParent(){
        guard let pere = pere,let mere = mere else {
            return
        }
        pere.afficherNom()
        mere.afficherNom()
    }
    
    
    
    enum Gender {
        case Male
        case Female
    }
    
}
