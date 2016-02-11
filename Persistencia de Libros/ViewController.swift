//
//  ViewController.swift
//  Persistencia de Libros
//
//  Created by Telecomunicaciones Abiertas de México on 2/11/16.
//  Copyright © 2016 Telecomunicaciones Abiertas de México. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var contexto: NSManagedObjectContext? = nil
    
    @IBOutlet weak var ISBNLbl: UILabel!
    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var autorLbl: UILabel!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var buscarTxt: UITextField!    
    
    var codigo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext                
        
        ISBNLbl.text = ""
        tituloLbl.text = ""
        autorLbl.text = ""
        coverImg.image = nil
        
        if (codigo != ""){
            buscarTxt.hidden = true
            print("Vengo de una celda")
        } else {
            buscarTxt.hidden = false
            self.title = "Detalle libro"
            print("Vengo de agregar")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buscar_(sender: UITextField) {
        
        let result_ISBN = sender.text!
        
        let seccionEnt = NSEntityDescription.entityForName("Seccion", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEnt?.managedObjectModel.fetchRequestFromTemplateWithName("petSeccion", substitutionVariables: ["codigo": result_ISBN])
        
        do {
            let verificar = try self.contexto?.executeFetchRequest(peticion!)
            if (verificar?.count > 0){
                return
            }
        } catch {
        
        }
        
        

        let openLib = self.sincrono(result_ISBN);
        
        
        if (openLib.error == 0){
        
            ISBNLbl.text = result_ISBN
            tituloLbl.text = openLib.title
            autorLbl.text = openLib.autor

            if let url  = NSURL(string: openLib.img), data = NSData(contentsOfURL: url){
                coverImg.image = UIImage(data: data)
            } else {
                coverImg.image = nil
            }
            
            
            //Agregamos nuevo valor a DB
            let newSeccion = NSEntityDescription.insertNewObjectForEntityForName("Seccion", inManagedObjectContext: self.contexto!)
            
            newSeccion.setValue(result_ISBN, forKey: "codigo")
            newSeccion.setValue(openLib.title, forKey: "titulo")
            newSeccion.setValue(openLib.autor, forKey: "autores")
            newSeccion.setValue(openLib.img, forKey: "imagen")
            
            do {
                try self.contexto?.save()
            } catch {
            
            }
            
            sender.text = nil
            sender.resignFirstResponder()
            
            
        } else {
        
            
            ISBNLbl.text = ""
            tituloLbl.text = ""
            autorLbl.text = ""
            coverImg.image = nil
            
            let alert = UIAlertController(title: "Libros", message: "No se encontro el NSBN en la base de datos", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                print("Ok")
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
            
        }
        
        print(sincrono(sender.text!))
    }
    
    func sincrono(ISBN: String) -> (error: Int, errorCode: String, title: String, autor: String, img: String) {
        
        let newString = ISBN.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + newString
        
        print(urls)
        let url = NSURL(string: urls)
        
        let datos = NSData(contentsOfURL: url!)
        var tituloBook: String = ""
        var autorBook: String = ""
        var coverBook: String = ""
        var errorBook: Int = 0
        var errorCode: String = ""
        
        if(datos != nil){
            
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!,
                    options:  NSJSONReadingOptions.MutableLeaves)
                
                let dico1 = json as! NSDictionary
                
                let ISBN_no: String = "ISBN:" + ISBN
                if( dico1[ISBN_no] == nil ){
                    
                    print("JSON no data")
                    errorBook = 1
                    errorCode = "No hay datos de este ISBN"
                    
                } else {
                    
                    let dico2 = dico1[ISBN_no] as!  NSDictionary
                    tituloBook = dico2["title"] as! NSString as String
                    
                    
                    if( dico2["authors"] == nil ){
                        autorBook = "Sin Autor"
                    } else {
                        let dico3 = dico2["authors"] as!  NSArray as Array
                        let a = dico3.count
                        var b = 0
                        for (nameISBN) in dico3 {
                            b += 1
                            let dico4 = nameISBN["name"] as!  NSString as String
                            autorBook += "\(dico4)";
                            autorBook += (b < a ? ", " : "")
                        }
                        
                    }
                    
                    if( dico2["cover"] == nil ){
                        coverBook = "http://vignette2.wikia.nocookie.net/thewalkingdead/images/d/d1/Sin_foto.png/revision/latest?cb=20141021181525&path-prefix=es"
                    } else {
                        let dico5 = dico2["cover"] as!  NSDictionary
                        coverBook = dico5["medium"] as!  NSString as String
                    }

                }
            }
                
            catch _ {
                
            }
            
            print(" \(errorBook) - \(errorCode) - \(tituloBook) - \(autorBook) - \(coverBook)")
            return (errorBook, errorCode, tituloBook, autorBook, coverBook)
            
            
            
        } else {
            return (1, "Problemas de Conexión, revisa tu conexión e intenta nuevamente",tituloBook, autorBook, coverBook)
        }
        
        
        
    }
    

}

