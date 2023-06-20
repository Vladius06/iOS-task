//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UITableViewController {
    
    private let dataManager:DataManager = DataManager()
    private var market:Market? = nil
    private let favouritesManager = FavouritesManager.self
    
    private var quotes: [Quote] = []
    private var favouriteSymbols: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateFavourites()
        subscribeToFavouritesChange()
        loadQuotes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteTableViewCell.reuseId, for: indexPath)
        if let quoteCell = cell as? QuoteTableViewCell {
            let quote = quotes[indexPath.row]
            quoteCell.quote = quote
            
            if let symbol = quote.symbol {
                quoteCell.isFavourite = favouriteSymbols.contains(symbol)
            } else {
                quoteCell.isFavourite = false
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetais(of: quotes[indexPath.row])
    }
}

private extension QuotesListViewController {
    func setupTableView() {
        tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: QuoteTableViewCell.reuseId)
        let refresControl = UIRefreshControl()
        refresControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.refreshControl = refresControl
    }
    
    func showLoading(_ isLoading: Bool) {
        refreshControl?.isEnabled = !isLoading
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    @objc func pullToRefresh() {
        loadQuotes()
    }
    
    func loadQuotes() {
        showLoading(true)
        dataManager.fetchQuotes { [weak self] result in
            DispatchQueue.main.async {
                self?.handle(result)
            }
        }
    }
    
    func subscribeToFavouritesChange() {
        NotificationCenter.default.addObserver(
            forName: favouritesManager.updateNotificationName,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateFavourites()
                self?.tableView.reloadData()
            }
    }
    
    func updateFavourites() {
        favouriteSymbols = Set(favouritesManager.favouriteSymbols ?? [])
    }
    
    func handle(_ quotesResult: Result<[Quote], Error>) {
        showLoading(false)
        switch quotesResult {
        case let .success(quotes):
            self.quotes = quotes
            tableView.reloadData()
        case let .failure(error):
            handle(error)
        }
    }
    
    func handle(_ error: Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showDetais(of quote: Quote) {
        let details = QuoteDetailsViewController(quote: quote)
        navigationController?.pushViewController(details, animated: true)
    }
}
