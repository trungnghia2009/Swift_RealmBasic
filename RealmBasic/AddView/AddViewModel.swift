//
//  AddViewModel.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import Foundation
import RealmSwift
import Combine

class AddViewModel {
    let addButtonState = PassthroughSubject<Bool, Never>()
    let titleWarningState = PassthroughSubject<Bool, Never>()
    let subtitleWarningState = PassthroughSubject<Bool, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    private let realmManager: BookRealmService
    
    init(realmManager: BookRealmService = BookRealmManager(config: RealmConfig.shared.config)) {
        self.realmManager = realmManager
    }
    
    func validateInput(title: String?, subtitle: String?, price: String?) {
        guard let titleCount = title?.count,
              let subtitleCount = subtitle?.count,
              let priceCount = price?.count
        else {
            addButtonState.send(false)
            return
        }
        
        (titleCount > 3 && subtitleCount > 5 && priceCount > 0) ? addButtonState.send(true) : addButtonState.send(false)
    }
    
    func setTitleWarningState(title: String?) {
        guard let titleCount = title?.count else {
            titleWarningState.send(true)
            return
        }
        titleCount > 3 ? titleWarningState.send(false) : titleWarningState.send(true)
    }
    
    func setSubtitleWarningState(title: String?) {
        guard let subtitleCount = title?.count else {
            subtitleWarningState.send(true)
            return
        }
        subtitleCount > 5 ? subtitleWarningState.send(false) : subtitleWarningState.send(true)
    }
    
    func addBook(title: String?, subtitle: String?, price: String?) {
        realmManager.addBook(title: title, subtitle: subtitle, price: price)
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { _ in }.store(in: &subscriptions)
    }
}
