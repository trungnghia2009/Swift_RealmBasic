//
//  HomeViewModel.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import RealmSwift
import Combine

class HomeViewModel {
    
    private var books = [Book]()
    private var subscriptions = Set<AnyCancellable>()
    private let realmManager: BookRealmService
    
    let trashButtonState = PassthroughSubject<Bool, Never>()
    let onReloadTableView = PassthroughSubject<Void, Never>()
    
    init(realmManager: BookRealmService = BookRealmManager(config: RealmConfig.shared.config)) {
        self.realmManager = realmManager
    }
    
    func getBooks() -> [Book] {
        return books
    }
    
    func setBooks(books: [Book]) {
        self.books = books
    }
    
    func getBook(at index: Int) -> Book {
        return books[index]
    }
    
    func getNumberOfBook() -> Int {
        return books.count
    }
    
    func fetchBooks() {
        realmManager.fetchBooks()
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] books in
                self?.books = books
                self?.onReloadTableView.send(())
            }.store(in: &subscriptions)
    }
    
    func deleteBook(book: Book) {
        realmManager.deleteBook(book: book)
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] _ in
                self?.fetchBooks()
            }.store(in: &subscriptions)
    }
    
    func deleteAll() {
        realmManager.deleteAll()
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] _ in
                self?.fetchBooks()
            }.store(in: &subscriptions)
    }
    
    func setupRealmObserver() {
        realmManager.setupRealmObserver()
            .sink { completion in
                print("setupRealmObserver Completion: \(completion)")
            } receiveValue: { [weak self] value in
                self?.trashButtonState.send(value)
            }.store(in: &subscriptions)
    }
    
    
    
}
