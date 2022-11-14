//
//  AddViewController.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import UIKit
import Combine

protocol AddViewControllerDelegate: AnyObject {
    func didTapAddButton()
}

class AddViewController: UIViewController {

    private let realm = BookRealmManager.shared
    private let viewModel = AddViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleWarningLabel: UILabel!
    
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var subtitleWarningLabel: UILabel!
    
    @IBOutlet weak var priceTextField: UITextField!
    @Published @IBOutlet var addButton: UIButton!
    
    weak var delegate: AddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        addButton.isEnabled = false
        setupTextField()
        setupObserver()
    }
    
    private func setupTextField() {
        titleTextField.delegate = self
        subtitleTextField.delegate = self
        priceTextField.delegate = self
    }
    
    private func setupObserver() {
        // Input
        titleTextField
            .publisher(for: .editingChanged)
            .sink { [weak self] textField in
                self?.viewModel.setTitleWarningState(title: textField.text)
            }.store(in: &subscriptions)
        
        subtitleTextField
            .publisher(for: .editingChanged)
            .sink { [weak self] textField in
                self?.viewModel.setSubtitleWarningState(title: textField.text)
            }.store(in: &subscriptions)
        
        titleTextField.publisher(for: .editingChanged)
            .combineLatest(subtitleTextField.publisher(for: .editingChanged), priceTextField.publisher(for: .editingChanged))
            .sink { [weak self] (textField1, textField2, textField3) in
                self?.viewModel.validateInput(title: textField1.text, subtitle: textField2.text, price: textField3.text)
            }.store(in: &subscriptions)
        
        // Output
        viewModel.titleWarningState
            .sink { [weak self] value in
                switch value {
                case true: self?.titleWarningLabel.isHidden = false
                case false: self?.titleWarningLabel.isHidden = true
                }
            }.store(in: &subscriptions)
        
        viewModel.subtitleWarningState
            .sink { [weak self] value in
                switch value {
                case true: self?.subtitleWarningLabel.isHidden = false
                case false: self?.subtitleWarningLabel.isHidden = true
                }
            }.store(in: &subscriptions)
        
        viewModel.addButtonState
            .sink { [weak self] value in
                switch value {
                case true: self?.addButton.isEnabled = true
                case false: self?.addButton.isEnabled = false
                }
            }.store(in: &subscriptions)
        
        addButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                print("Did tap add button...")
                self.realm.addBook(title: self.titleTextField.text,
                                   subtitle: self.subtitleTextField.text,
                                   price: self.priceTextField.text)
                self.dismiss(animated: true) {
                    self.delegate?.didTapAddButton()
                }
            }.store(in: &subscriptions)
    }
    
    @IBAction func didTaoCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
