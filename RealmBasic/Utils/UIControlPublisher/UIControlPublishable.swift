//
//  UIControlPublishableProtocol.swift
//  RealmBasic
//
//  Created by trungnghia on 02/10/2022.
//

import UIKit
import Combine

protocol UIControlPublishable: UIControl {}

extension UIControlPublishable {
    func publisher(for event: UIControl.Event) -> InteractionPublisher<Self> {
        return InteractionPublisher(control: self, event: event)
    }
}

extension UIControl: UIControlPublishable {}
