//
//  EventBusApplicationBecomeActive.swift
//  RealmBasic
//
//  Created by trungnghia on 14/11/2022.
//

import Foundation
import Combine

final class EventBusApplicationBecomeActive {
    static private(set) var active: Bool = false
    static private let subject =  PassthroughSubject<Bool, Never>()
    static var activeObserver: AnyPublisher<Bool, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    static func updateActiveState(state: Bool) {
        active = state
        subject.send(active)
    }
}

//Observer
class SomeView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func doStuff() {
        EventBusApplicationBecomeActive.activeObserver
            .sink { value in
                //Handling
            }.store(in: &subscriptions)
    }
}

//Send
class AppDelegateA {
    func applicationDidBecomeActive() {
        EventBusApplicationBecomeActive.updateActiveState(state: true)
        print(EventBusApplicationBecomeActive.active)
    }
}

