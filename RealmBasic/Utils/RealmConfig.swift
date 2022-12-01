//
//  RealmConfig.swift
//  RealmBasic
//
//  Created by trungnghia on 01/12/2022.
//

import Foundation
import RealmSwift

class RealmConfig {
    static let shared = RealmConfig()
    private init() {}
    
    let config = Realm.Configuration(
        
        schemaVersion: 1,  //Increment this each time your schema changes
        migrationBlock: { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < 1) {
                //If you need to transfer any data
                //(in your case you don't right now) you will transfer here
                
            }
        })
}
