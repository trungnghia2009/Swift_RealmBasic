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
    
    func validateInput(subtitle: String?, price: String?) {
        guard let subtitleCount = subtitle?.count,
              let priceCount = price?.count
        else {
            okButtonState.send(false)
            return
        }
        
        if subtitleCount > 5 && priceCount > 0 {
            okButtonState.send(true)
        } else {
            okButtonState.send(false)
        }
    }
    
    func setSubtitleWarningState(title: String?) {
        guard let subtitleCount = title?.count else {
            subtitleWarningState.send(true)
            return
        }
        subtitleCount > 5 ? subtitleWarningState.send(false) : subtitleWarningState.send(true)
    }
}
