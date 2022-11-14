//
//  Book.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import RealmSwift

final class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var price = 0.0
    
    override static func primaryKey() -> String? { //for updating
        return "title"
    }
}
