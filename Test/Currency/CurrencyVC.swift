//
//  CurrencyVC.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit

struct CurrencyViewModel {
    let currencyArray: [Currency]
    let cells: [CurrencyCells]
    
    init(with cells: [CurrencyCells] = [], currencyArray: [Currency]) {
        self.currencyArray = currencyArray
        self.cells = cells
    }
}

enum CurrencyCells {
    case currenceCell(model: Currency, type: CurrencyTableViewCellType)
}

class CurrencyVC: UIViewController {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            CurrencyTableViewCell.self,
            forCellReuseIdentifier: "CurrencyTableViewCell"
        )
        return tableView
    }()
    
    // MARK: - Properties.
    
    private var viewModel: CurrencyViewModel?
    private var selectedItems: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        CurrencyManager.shared.fetchCurrencyList { currencyArray in
            self.generateViewModel(from: currencyArray)
        }
    }
    
    private func generateViewModel(from currencyArray: [Currency]) {
        var cells: [CurrencyCells] = []
        
        currencyArray.forEach {
            if selectedItems.contains($0) {
                cells.append(.currenceCell(model: $0, type: .selected))
            } else {
                cells.append(.currenceCell(model: $0, type: .notSelected))
            }
        }
        
        viewModel = CurrencyViewModel(with: cells, currencyArray: currencyArray)
        tableView.reloadData()
    }
    
}

extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.currencyArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case let .currenceCell(model, type):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrencyTableViewCell",
                for: indexPath
            ) as! CurrencyTableViewCell
            
            cell.configureCell(witn: model, type: type)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let currency = viewModel?.currencyArray[indexPath.row],
            let currencyArray = viewModel?.currencyArray
        else { return }
        if selectedItems.contains(currency) {
            guard let index = selectedItems.firstIndex(where: { $0 == currency } ) else { return }
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(currency)
        }
        generateViewModel(from: currencyArray)
    }
    
}

private extension CurrencyVC {
    
    func setUpConstraints() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}
