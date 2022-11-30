//
//  DetailViewController.swift
//  RealmBasic
//
//  Created by trungnghia on 17/09/2022.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var subtitleWarning: UILabel!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    static let identifier = String(describing: DetailViewController.self)
    
    var book: Book?
    var controller: HomeViewController?
    private let viewModel = DetailViewModel()
    private let realm = BookRealmManager.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For testing delegate and closure
        controller?.delegate = self
        controller?.callForward = { string in
            print("Received: \(string)")
        }
        
        setupUI()
        setupTextField()
        setupObserver()
    }
    
    deinit {
        print("Deint.....")
    }
    
    private func setupUI() {
        okButton.isEnabled = false
        title = "Edit"
        bookTitle.text = book?.title
        subtitleTextField.text = book?.subTitle
        priceTextField.text = String(book!.price)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subtitleTextField.becomeFirstResponder()
        }
    }
    
    private func setupTextField() {
        subtitleTextField.delegate = self
        priceTextField.delegate = self
    }
    
    private func setupObserver() {
        // Input
        subtitleTextField
            .publisher(for: .editingChanged)
            .sink { [weak self] textField in
                self?.viewModel.setSubtitleWarningState(title: textField.text)
            }.store(in: &subscriptions)
        
        subtitleTextField.publisher(for: .editingChanged)
            .sink { [weak self] subtitleTextField in
                self?.viewModel.validateInput(subtitle: subtitleTextField.text, price: self?.priceTextField.text)
            }.store(in: &subscriptions)
        
        priceTextField.publisher(for: .editingChanged)
            .sink { [weak self] priceTextField in
                self?.viewModel.validateInput(subtitle: self?.subtitleTextField.text, price: priceTextField.text)
            }.store(in: &subscriptions)
        
        // Output
        viewModel.subtitleWarningState
            .sink { [weak self] value in
                switch value {
                case true: self?.subtitleWarning.isHidden = false
                case false: self?.subtitleWarning.isHidden = true
                }
            }.store(in: &subscriptions)
        
        viewModel.okButtonState
            .sink { [weak self] value in
                switch value {
                case true: self?.okButton.isEnabled = true
                case false: self?.okButton.isEnabled = false
                }
            }.store(in: &subscriptions)
        
        okButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.realm.updateBook(subtitle: self.subtitleTextField.text,
                                      price: self.priceTextField.text,
                                      book: self.book)
                self.navigationController?.popViewController(animated: true)
            }.store(in: &subscriptions)
        
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController: HomeViewControllerDelegate {
    func doSomething() {
        print("Received data from HomeViewController via delegate....")
    }
}
