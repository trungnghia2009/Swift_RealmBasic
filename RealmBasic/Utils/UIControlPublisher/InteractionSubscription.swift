//
//  InteractionSubscription.swift
//  RealmBasic
//
//  Created by trungnghia on 02/10/2022.
//

import UIKit
import Combine

class InteractionSubscription<S: Subscriber, C: UIControl>: Subscription where S.Input == C {
    
    private let subscriber: S?
    private weak var control: C?
    private let event: UIControl.Event
    
    init(subscriber: S, control: C?, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        self.control?.addTarget(self, action: #selector(handleEvent), for: event)
    }
    
    @objc private func handleEvent(_ sender: UIControl) {
        _ = self.subscriber?.receive(sender as! C)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }
    
    func cancel() {
        self.control?.removeTarget(self, action: #selector(handleEvent), for: self.event)
        self.control = nil
    }
    
}
