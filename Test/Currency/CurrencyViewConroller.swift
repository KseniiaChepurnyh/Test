//
//  CurrencyViewConroller.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit


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
        return tableView
    }()
    
    
    // MARK: - Properties.
    
    private var viewModel: CurrencyViewModel?
    private var selectedItems: [Currency] = []
    
    
    // MARK: - Life Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        addContinueButton()
        CurrencyManager.shared.fetchCurrencyList { currencyArray in
            self.generateViewModel(from: currencyArray)
        }
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate.

extension CurrencyViewConroller: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.currencyArray.count ?? 0
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = viewModel?.cells[indexPath.row]
        
        if case let .currencyCell(model, _) = cellModel {
            guard let currencyArray = viewModel?.currencyArray else { return }
            if selectedItems.contains(model) {
                guard let index = selectedItems.firstIndex(where: { $0 == model } ) else { return }
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(model)
            }
            setContinueButtonHidden(selectedItems.count > 0 ? false : true)
            generateViewModel(from: currencyArray)
        }
    }
    
}


// MARK: - Private Methods.

private extension CurrencyViewConroller {
    
    func generateViewModel(from currencyArray: [Currency]) {
        var cells: [CurrencyCells] = []
        
        cells.append(.titleCell(text: "Выберите валюты"))
        currencyArray.forEach {
            if selectedItems.contains($0) {
                cells.append(.currencyCell(model: $0, type: .selected))
            } else {
                cells.append(.currencyCell(model: $0, type: .notSelected))
            }
        }
        
        viewModel = CurrencyViewModel(with: cells, currencyArray: currencyArray)
        tableView.reloadData()
    }
    
    func setContinueButtonHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = isHidden ? 0 : 1
        }
    }
    
    @objc func didTapOnContinueButton() {
        let vc = MyCurrenciesViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
