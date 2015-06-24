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
        //let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        
        let query = CKQuery(recordType: "Vacinas",
            predicate:  predicate)
        //query.sortDescriptors = [sort]
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




//import Foundation
//import CloudKit
//
//protocol CloudKitDelegate
//{
//    func errorUpdating(error: NSError)
//    func modelUpdated()
//}
//
//class CloudKitHelper {
//    
//    class func sharedInstance() -> CloudKitHelper
//    {       return CloudKitHelperSingleton    }
//    
//    var delegate: CloudKitDelegate?
//    
//    var vacinas = [VacinasCloud]()
//    
//    let container: CKContainer
//    let publicDB: CKDatabase
//    
//    init()
//    {
//        container = CKContainer.defaultContainer()
//        publicDB = container.publicCloudDatabase
//    }
//    
//    func saveRecord(vacina: NSString)
//    {
//        let vacinaRecord = CKRecord(recordType: "Vacinas")
//        vacinaRecord.setValue(vacina, forKey: "Name")
//        publicDB.saveRecord(vacinaRecord, completionHandler: {(record, error) - &gt; Void in NSLog("Saved to cloud kit") })
//    }
//
//    
//    func fetchVacinas(insertedRecord: CKRecord?)
//    {
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Vacinas", predicate: predicate)
//        publicDB.performQuery(query, inZoneWithID: nil)
//        {
//            results, error in
//            if error != nil
//            {
//                dispatch_async(dispatch_get_main_queue())
//                {
//                    self.delegate?.errorUpdating(error)
//                    return
//                }
//            } else {
//                self.vacinas.removeAll()
//                for record in results {
//                    let vacina = VacinasCloud(record: record as! CKRecord, database: self.publicDB)
//                    self.vacinas.append(vacina)
//                    
//                    //quando o CoreData estiver funcionando fazer aqui...
//                }
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.delegate?.modelUpdated()
//                }
//            }
//        }
//    }
//   
//}
//
//let CloudKitHelperSingleton = CloudKitHelper()
