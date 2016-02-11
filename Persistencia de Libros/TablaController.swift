//
//  TablaController.swift
//  Persistencia de Libros
//
//  Created by Telecomunicaciones Abiertas de México on 2/11/16.
//  Copyright © 2016 Telecomunicaciones Abiertas de México. All rights reserved.
//

import UIKit
import CoreData

class TablaController: UITableViewController {
    
    private var libros : Array<Array<String>> = Array<Array<String>>()
    var contexto: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Seccion", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petSecciones")
        
        do {
            let seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for sccn in seccionesEntidad! {
                let codigo = sccn.valueForKey("codigo") as! String
                let titulo = sccn.valueForKey("titulo") as! String
                let autor = sccn.valueForKey("autores") as! String
                let imgn = sccn.valueForKey("imagen") as! String
                
                print("c: \(codigo), t: \(titulo), a: \(autor), i: \(imgn)\n")
            }
            
        } catch {
        
        }

        
        
        self.libros.append(["0201087987","Assembly language fundamentals","Rina Yarmish","https://covers.openlibrary.org/b/id/7018557-M.jpg"])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libros.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.libros[indexPath.row][0]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        
        
        let ccd = segue.destinationViewController as! ViewController
        let indexPath_ = self.tableView.indexPathForSelectedRow

        if ((indexPath_ != nil)) {
            ccd.codigo = self.libros[indexPath_!.row][1]
            print("Voy desde una celda, con valor: \(self.libros[indexPath_!.row][1])")
        } else {
            print("Voy desde agregar, sin valor")
        }
                
        
    }


}
