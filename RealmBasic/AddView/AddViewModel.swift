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
    
    func validateInput(title: String?, subtitle: String?, price: String?) {
        guard let titleCount = title?.count,
              let subtitleCount = subtitle?.count,
              let priceCount = price?.count
        else {
            addButtonState.send(false)
            return
        }
        
        if titleCount > 3 && subtitleCount > 5 && priceCount > 0 {
            addButtonState.send(true)
        } else {
            addButtonState.send(false)
        }
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
}
