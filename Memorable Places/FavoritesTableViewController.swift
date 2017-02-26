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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favoritePlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        // Configure the cell...
        if(favoritePlaces.count > 0){
            let annotation: MKPointAnnotation = favoritePlaces[indexPath.row]!
            cell.textLabel?.text = annotation.title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        annotationToDisplay = favoritePlaces[indexPath.row]!
        
        self.performSegue(withIdentifier: "showPlaceOnMap", sender: self)
        
        return indexPath
    }

}
