//
//  CloudKitHelper.swift
//  Vacinas
//
//  Created by Ana Elisa Pessoa Aguiar on 24/06/15.
//  Copyright (c) 2015 Ana Elisa Pessoa Aguiar. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitHelperDelegate
{
    func errorUpdating(error: NSError)
    func modelUpdated()
}

class CloudKitHelper {
    
    class func sharedInstance() -> CloudKitHelper
    {       return CloudKitHelperSingleton      }
    
    var delegate: CloudKitHelperDelegate?
    
    var vacinas = [VacinasCloud]()
    
    let container: CKContainer
    let publicDB: CKDatabase
    
    init()
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }
    
   
}

let CloudKitHelperSingleton = CloudKitHelper()
