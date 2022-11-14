//
//  PublisherForUIControl.swift
//  RealmBasic
//
//  Created by trungnghia on 02/10/2022.
//

/// https://www.avanderlee.com/swift/custom-combine-publisher/

import UIKit
import Combine

struct InteractionPublisher<C: UIControl>: Publisher {
    
    typealias Output = C
    typealias Failure = Never
    
    private weak var control: C?
    private let event: UIControl.Event
    
    init(control: C, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Never, S.Input == C {
        guard let control = control else {
            subscriber.receive(completion: .finished)
            return
        }
        
        let subscription = InteractionSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}
