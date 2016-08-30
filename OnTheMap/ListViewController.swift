//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit


// MARK: - ListViewController: UITableViewController
class ListViewController: UITableViewController {


}

// MARK: - ListViewController: UITableViewDelegate, UITableViewDataSource
extension ListViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.sharedInstance().studentInfo.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell")!
        let info = UdacityClient.sharedInstance().studentInfo[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = info.firstName + info.lastName
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
}