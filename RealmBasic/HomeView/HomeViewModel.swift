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
    private var notificationToken: NotificationToken?
    
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
    
}

enum APIError: Error {
    case invalidURL
}

struct BaseResponse {
    let data: Data
    let response: URLResponse
}
