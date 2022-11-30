//
//  UITableView+Extension.swift
//  RealmBasic
//
//  Created by trungnghia on 30/11/2022.
//

import UIKit

extension UITableView {
    func setEmptyMessage(message: String, size: CGFloat) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
