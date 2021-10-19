//
//  CurrencyViewConroller.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit
import SnapKit

// MARK: - View Model.

struct CurrencyViewModel {
    let currencyArray: [Currency]
    let cells: [CurrencyCells]
    
    init(with cells: [CurrencyCells] = [], currencyArray: [Currency]) {
        self.currencyArray = currencyArray
        self.cells = cells
    }
}

enum CurrencyCells {
    case currencyCell(model: Currency, type: CurrencyTableViewCellType)
    case titleCell(text: String)
    case spacingCell(height: CGFloat)
}

final class CurrencyViewConroller: UIViewController {
    
    // MARK: - UI Properties.
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(
            CurrencyTableViewCell.self,
            forCellReuseIdentifier: "CurrencyTableViewCell"
        )
        tableView.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: "TitleTableViewCell"
        )
        tableView.register(
            SpacingTableViewCell.self,
            forCellReuseIdentifier: "SpacingTableViewCell"
        )
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    
    
    // MARK: - Properties.
    
    private var viewModel: CurrencyViewModel?
    private var selectedCurrencies: [Currency] = []
    private var originalCurrencies: [Currency] = []
    private var filteredCurrencies: [Currency] = []
    
    
    // MARK: - Life Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        addContinueButton()
        navigationItem.searchController = searchController
        
        DBManager.shared.getCurrencies { [unowned self] currency in
            self.selectedCurrencies = currency
            self.setContinueButtonHidden(self.selectedCurrencies.count > 0 ? false : true)
            CurrencyManager.shared.fetchCurrencyList { [unowned self] currencyArray in
                self.originalCurrencies = currencyArray
                self.generateViewModel(from: currencyArray)
            }
        }
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate.

extension CurrencyViewConroller: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case let .currencyCell(model, type):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrencyTableViewCell",
                for: indexPath
            ) as! CurrencyTableViewCell
            cell.configureCell(witn: model, type: type)
            return cell
        case let .titleCell(text):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TitleTableViewCell",
                for: indexPath
            ) as! TitleTableViewCell
            cell.configureCell(with: text)
            return cell
        case .spacingCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SpacingTableViewCell",
                for: indexPath
            ) as! SpacingTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case let .spacingCell(height):
            return height
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = viewModel?.cells[indexPath.row]
        
        if case let .currencyCell(model, _) = cellModel {
            guard let currencyArray = viewModel?.currencyArray else { return }
            if selectedCurrencies.contains(model) {
                guard let index = selectedCurrencies.firstIndex(where: { $0 == model } )
                else { return }
                selectedCurrencies.remove(at: index)
            } else {
                selectedCurrencies.append(model)
            }
            setContinueButtonHidden(selectedCurrencies.count > 0 ? false : true)
            generateViewModel(from: currencyArray)
        }
    }
    
}


// MARK: - UISearchResultsUpdating.

extension CurrencyViewConroller: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
            if text.count > 0 {
                filteredCurrencies = originalCurrencies.filter(
                    {
                        $0.name.lowercased().range(of: text) != nil
                    }
                )
                generateViewModel(from: filteredCurrencies)
            } else {
                generateViewModel(from: originalCurrencies)
            }
        }
    }
    
}


// MARK: - Private Methods.

private extension CurrencyViewConroller {
    
    func generateViewModel(from currencies: [Currency]) {
        var cells: [CurrencyCells] = []
        
        cells.append(.titleCell(text: "Выберите валюты"))
        cells.append(.spacingCell(height: 20))
        currencies.forEach {
            if selectedCurrencies.contains($0) {
                cells.append(.currencyCell(model: $0, type: .selected))
                cells.append(.spacingCell(height: 10))
            } else {
                cells.append(.currencyCell(model: $0, type: .notSelected))
                cells.append(.spacingCell(height: 10))
            }
        }
        
        viewModel = CurrencyViewModel(with: cells, currencyArray: currencies)
        tableView.reloadData()
    }
    
    func setContinueButtonHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = isHidden ? 0 : 1
        }
    }
    
    @objc func didTapOnContinueButton() {
        DBManager.shared.saveCurrencies(for: selectedCurrencies)
        let vc = UINavigationController(rootViewController: MyCurrenciesViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func addContinueButton() {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(didTapOnContinueButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem?.customView?.alpha = 0
    }
    
}


// MARK: - Constraints.

private extension CurrencyViewConroller {
    
    func setUpConstraints() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}
