//
//  CloudKitHelper.swift
//  Vacinas
//
//  Created by Ana Elisa Pessoa Aguiar on 24/06/15.
//  Copyright (c) 2015 Ana Elisa Pessoa Aguiar. All rights reserved.
//


import Foundation
import CloudKit

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}


class CloudKitHelper {
    var container : CKContainer
    var publicDB : CKDatabase
    
    var delegate : CloudKitDelegate?
    var vacinas = [VacinasCloud]()
    
    class func sharedInstance() -> CloudKitHelper
    {       return cloudKitHelper       }
    
    init()
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }
    
    func saveRecord(todo : NSString)
    {
        let todoRecord = CKRecord(recordType: "Vacinas")
        todoRecord.setValue(todo, forKey: "Name")
        publicDB.saveRecord(todoRecord, completionHandler: { (record, error) -> Void in
            NSLog("Before saving in cloud kit : \(self.vacinas.count)")
            NSLog("Saved in cloudkit")
            self.fetchVacinas(record)
        })
    }
    
    func fetchVacinas(insertedRecord: CKRecord?)
    {
        let predicate = NSPredicate(value: true)
        
        // Descriptor para Ordenar o array por nome e ordem crescente
        let sort = NSSortDescriptor(key: "Name", ascending: true)
        
        let query = CKQuery(recordType: "Vacinas",
            predicate:  predicate)
        
        // Ordena usando o Descriptor
        query.sortDescriptors = [sort]
        
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.errorUpdating(error)
                    return
                }
            } else {
                
                self.vacinas.removeAll()
                for record in results{
                    let todo = VacinasCloud(record: record as! CKRecord, database: self.publicDB)
                    self.vacinas.append(todo)
                }
                if let tmp = insertedRecord {
                    let todo = VacinasCloud(record: insertedRecord! as CKRecord, database: self.publicDB)
                    self.vacinas.insert(todo, atIndex: 0)
                }
                NSLog("fetch after save : \(self.vacinas.count)")
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.modelUpdated()
                    return
                }
            }
        }
    }
}
let cloudKitHelper = CloudKitHelper()
