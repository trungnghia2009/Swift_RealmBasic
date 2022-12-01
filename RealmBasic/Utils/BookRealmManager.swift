//
//  BookRealmManager.swift
//  RealmBasic
//
//  Created by trungnghia on 17/09/2022.
//

import RealmSwift
import Foundation
import Combine

protocol BookRealmService: AnyObject {
    func fetchBooks() -> AnyPublisher<[Book], Error>
    func deleteBook(book: Book) -> AnyPublisher<Void, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
    func addBook(title: String?, subtitle: String?, price: String?) -> AnyPublisher<Void, Error>
    func updateBook(subtitle: String?, price: String?, book: Book?) -> AnyPublisher<Void, Error>
    func setupRealmObserver() -> AnyPublisher<Bool, Error>
}

class BookRealmManager: BookRealmService {
    
    private let config: Realm.Configuration
    private var notificationToken: NotificationToken?
    
    init(config: Realm.Configuration) {
        self.config = config
    }
    
    func fetchBooks() -> AnyPublisher<[Book], Error> {
        Future<[Book], Error> { promise in
            do {
                let realm = try Realm(configuration: self.config)
                let result = realm.objects(Book.self)
                let books = Array(result)
                promise(.success(books))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteBook(book: Book) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                let realm = try Realm(configuration: self.config)
                try realm.write {
                    realm.delete(book)
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                let realm = try Realm(configuration: self.config)
                try realm.write {
                    realm.deleteAll()
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func addBook(title: String?, subtitle: String?, price: String?) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let title = title,
                  let subtitle = subtitle,
                  let priceString = price, let price = Double(priceString)
            else {
                promise(.success(()))
                return
            }
            
            do {
                let realm = try Realm(configuration: self.config)
                let book = Book()
                book.title = title
                book.subTitle = subtitle
                book.price = price
                
                try realm.write {
                    realm.add(book)
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateBook(subtitle: String?, price: String?, book: Book?) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let book = book,
                  let subtitle = subtitle,
                  let priceString = price, let price = Double(priceString)
            else {
                promise(.success(()))
                return
            }
            
            do {
                let realm = try Realm(configuration: self.config)
                try realm.write {
                    book.subTitle = subtitle
                    book.price = price
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func setupRealmObserver() -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        
        do {
            let realm = try Realm(configuration: self.config)
            self.notificationToken = realm.objects(Book.self).observe { change in
                switch change {
                case .initial(let collectionType):
                    collectionType.count == 0 ? subject.send(false) : subject.send(true)
                case .update(let collectionType, _, _, _):
                    collectionType.count == 0 ? subject.send(false) : subject.send(true)
                case .error(let error):
                    print("Realm notification observer error: \(error)")
                }
            }
        } catch {
            subject.send(completion: .failure(error))
        }
        
        return subject.eraseToAnyPublisher()
    }
    
}
