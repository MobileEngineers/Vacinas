//
//  ViewController.swift
//  Vacinas
//
//  Created by Ana Elisa Pessoa Aguiar on 23/06/15.
//  Copyright (c) 2015 Ana Elisa Pessoa Aguiar. All rights reserved.
//


import UIKit
import CloudKit

class CloudKitTableViewController: UITableViewController, CloudKitDelegate {
    
    // MARK: - Indicator View
    
    var loadingView: UIView?
    
    var activityIndicator: UIActivityIndicatorView?
    
    //
    
    let model: CloudKitHelper = CloudKitHelper.sharedInstance()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loading()
        
        self.model.delegate = self;
        
        cloudKitHelper.fetchVacinas(nil)
        
    }
    
    func loading(){
        
        if self.loadingView == nil{
            self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            self.loadingView?.center = CGPointMake(self.view.center.x, self.view.center.y)
            self.loadingView?.backgroundColor = UIColor.blackColor()
            self.loadingView?.alpha = 0.5
            
        }
        self.view.addSubview(self.loadingView!)
        if self.activityIndicator == nil {
            
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            self.activityIndicator!.alpha = 1
            self.activityIndicator!.hidesWhenStopped = false
            self.activityIndicator!.center = CGPointMake(self.view.center.x, self.view.center.y)
            
        }
        
        self.loadingView!.addSubview(activityIndicator!)
        self.activityIndicator!.startAnimating()
        
    }
    
    func finishedLoading(){
        self.loadingView?.removeFromSuperview()
        self.activityIndicator!.removeFromSuperview()
    }
    
    
    func reloadData(){
        tableView.reloadData()
        self.finishedLoading()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {       return 1        }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        NSLog("\(cloudKitHelper.vacinas.count)")
        
        return cloudKitHelper.vacinas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = cloudKitHelper.vacinas[indexPath.row].nome
        return cell
    }
    
    func modelUpdated()
    {
        NSLog("Model refreshed \(cloudKitHelper.vacinas.count)")
        refreshControl?.endRefreshing()
        reloadData()
        
    }
    
    func errorUpdating(error: NSError)
    {
        let message = error.localizedDescription
        let alert = UIAlertView(title: "Error Loading Todos",
            message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

