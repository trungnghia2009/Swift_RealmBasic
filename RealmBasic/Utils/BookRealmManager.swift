//
//  BookRealmManager.swift
//  RealmBasic
//
//  Created by trungnghia on 17/09/2022.
//

import RealmSwift
import Foundation

class BookRealmManager {
    
    static let shared = BookRealmManager()
    
    private var notificationToken: NotificationToken?
    
    private var realm: Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("Realm error: \(error)")
            return nil
        }
    }
    
    private init() {}
    
    func fetchBooks(completion: ([Book]) -> ()) {
        if let results = realm?.objects(Book.self) {
            let books = Array(results)
            completion(books)
        } else {
            completion([Book]())
        }
    }
    
    func deleteBook(book: Book, completion: () -> ()) {
        do {
            try realm?.write({
                realm?.delete(book)
            })
            completion()
        } catch {
            print("Realm delete Error: \(error)")
        }
    }
    
    func deleteAll(completion: () -> ()) {
        do {
            try realm?.write{
                realm?.deleteAll()
            }
            completion()
        } catch {
            print("Realm delete all Error: \(error)")
        }
    }
    
    func addBook(title: String?, subtitle: String?, price: String?) {
        guard let title = title,
              let subtitle = subtitle,
              let priceString = price, let price = Double(priceString) else { return }
        
        do {
            let book = Book()
            book.title = title
            book.subTitle = subtitle
            book.price = price
            
            try realm?.write {
                realm?.add(book)
            }
        } catch {
            print("Realm add error: \(error)")
        }
    }
    
    func updateBook(subtitle: String?, price: String?, book: Book?) {
        guard let book = book,
              let subtitle = subtitle,
              let priceString = price, let price = Double(priceString) else { return }
        
        do {
            try realm?.write {
                book.subTitle = subtitle
                book.price = price
            }
        } catch {
            print("Realm update error: \(error)")
        }
    }
    
    func setupRealmObserver(deleteAllCompletion: @escaping (Bool) -> ()) {
        notificationToken = realm?.objects(Book.self).observe { change in
            switch change {
            case .initial(let collectionType):
                collectionType.count == 0 ? deleteAllCompletion(true) : deleteAllCompletion(false)
            case .update(let collectionType, _, _, _):
                collectionType.count == 0 ? deleteAllCompletion(true) : deleteAllCompletion(false)
            case .error(let error):
                print("Realm notification observer error: \(error)")
            }
            
        }
    }
}
