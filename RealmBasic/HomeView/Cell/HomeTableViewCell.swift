//
//  HomeTableViewCell.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: HomeTableViewCell.self)
    
    @IBOutlet private weak var myImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(book: Book) {
        self.titleLabel.text = book.title
        self.descriptionLabel.text = "\(book.subTitle) - \(book.price)$"
    }
    
}
