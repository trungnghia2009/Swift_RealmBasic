//
//  ViewController.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import UIKit
import RealmSwift
import Combine

protocol HomeViewControllerDelegate: AnyObject {
    func doSomething()
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    private let viewModel = HomeViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: HomeViewControllerDelegate? //For passing data from home to detail via delegate
    var callForward: ((String) -> ())? //For passing data from home to detail via closure
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupTableView()
        setupObserver()
        
        // For simulate asyn event
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.delegate?.doSomething()
            self.callForward?("I am here for you...")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBooks()
    }
    
    private func setupObserver() {
        viewModel.setupRealmObserver()
        
        viewModel.trashButtonState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.trashButton.isEnabled = value
            }.store(in: &subscriptions)
        
        viewModel.onReloadTableView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: HomeTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.rowHeight = 90
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController,
           let addVC = navigation.viewControllers.first as? AddViewController {
            addVC.delegate = self
        }
    }
    
    @IBAction func didTapTrashBtn(_ sender: Any) {
        print("Did tap trash button...")
        createDeleteAllAlert()
    }
    
    private func createDeleteAllAlert() {
        let alert = UIAlertController(title: "Delete All", message: "Do you wanna delete all books ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteAll()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bookCount = viewModel.getNumberOfBook()
        bookCount == 0 ? tableView.setEmptyMessage(message: "Please tap + to add new book.", size: 20) : tableView.restore()
        return bookCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell
        else { return UITableViewCell() }
        cell.setup(book: viewModel.getBook(at: indexPath.row))
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.getBook(at: indexPath.row)
        print("Did select cell number: \(selectedBook)")
        if let vc = storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController {
            vc.book = selectedBook
            vc.controller = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedBook = viewModel.getBook(at: indexPath.row)
            print("Deleting: \(selectedBook)")
            viewModel.deleteBook(book: selectedBook)
        }
    }
}

extension HomeViewController: AddViewControllerDelegate {
    func didTapAddButton() {
        print("Recieved value....")
        viewModel.fetchBooks()
    }
    
}
