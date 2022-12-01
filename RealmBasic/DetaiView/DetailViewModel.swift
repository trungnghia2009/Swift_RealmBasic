//
//  DetailViewModel.swift
//  RealmBasic
//
//  Created by trungnghia on 17/09/2022.
//

import Foundation
import RealmSwift
import Combine

class DetailViewModel {
    let okButtonState = PassthroughSubject<Bool, Never>()
    let subtitleWarningState = PassthroughSubject<Bool, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    private let realmManager: BookRealmService
    
    init(realmManager: BookRealmService = BookRealmManager(config: RealmConfig.shared.config)) {
        self.realmManager = realmManager
    }
    
    func validateInput(subtitle: String?, price: String?) {
        guard let subtitleCount = subtitle?.count,
              let priceCount = price?.count
        else {
            okButtonState.send(false)
            return
        }
        
        (subtitleCount > 5 && priceCount > 0) ? okButtonState.send(true) : okButtonState.send(false)
    }
    
    func setSubtitleWarningState(title: String?) {
        guard let subtitleCount = title?.count else {
            subtitleWarningState.send(true)
            return
        }
        subtitleCount > 5 ? subtitleWarningState.send(false) : subtitleWarningState.send(true)
    }
    
    func updateBook(subtitle: String?, price: String?, book: Book?) {
        realmManager.updateBook(subtitle: subtitle, price: price, book: book)
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { _ in
                // Not implemented
            }.store(in: &subscriptions)

    }
}
