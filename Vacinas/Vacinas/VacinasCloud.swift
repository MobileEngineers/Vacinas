//
//  VacinasCloud.swift
//  Vacinas
//
//  Created by Ana Elisa Pessoa Aguiar on 24/06/15.
//  Copyright (c) 2015 Ana Elisa Pessoa Aguiar. All rights reserved.
//

import UIKit
import CloudKit

class VacinasCloud: NSObject {
    
    var record: CKRecord!
    weak var database: CKDatabase!
    var nome: String!
    var detalhe: String!
    var meses: Int!
    
    var assetCount = 0
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        
        self.nome = record.objectForKey("") as! String
        self.detalhe = record.objectForKey("") as! String
        self.meses = record.objectForKey("") as! Int
    }
   
}
