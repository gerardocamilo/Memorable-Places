//
//  FavoritesTableViewController.swift
//  Memorable Places
//
//  Created by Gerardo Camilo on 14/6/15.
//  Copyright (c) 2015 ___GRCS___. All rights reserved.
//

import UIKit
import MapKit

var favoritePlaces = Dictionary<Int, MKPointAnnotation>();

class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        // println("numberOfRowsInSection: \(favoritePlaces.count)");
        return favoritePlaces.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        // print("IndexPathRow: \(indexPath.row).");
        // print("FavoritePlaces Count: \(favoritePlaces.count).");
        
        // Configure the cell...
        if(favoritePlaces.count > 0){

            let annotation: MKPointAnnotation = favoritePlaces[indexPath.row]!
            cell.textLabel?.text = annotation.title
            // print("AnnotationDesc: \(annotation.title).");
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        annotationToDisplay = favoritePlaces[indexPath.row]!
        
        self.performSegue(withIdentifier: "showPlaceOnMap", sender: self)
        
        return indexPath
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
