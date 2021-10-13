//
//  MyCurrenciesViewController.swift
//  Test
//
//  Created by Ксения Чепурных on 11.10.2021.
//

import UIKit

// MARK: - View Model.

struct MyCurrenciesViewModel {
    let records: [Record]
    let cells: [MyCurrenciesCells]
    
    init(with cells: [MyCurrenciesCells] = [], records: [Record]) {
        self.cells = cells
        self.records = records
    }
}

enum MyCurrenciesCells {
    case recordCell(model: Record)
    case titleCell(text: String)
    case spacingCell(height: CGFloat)
}

final class MyCurrenciesViewController: UIViewController {
    
    // MARK: - UI Properties.
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(
            RecordTableViewCell.self,
            forCellReuseIdentifier: "RecordTableViewCell"
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
    
    
    // MARK: - Properties.
    
    private var viewModel: MyCurrenciesViewModel?
    private var records: [Record] = []
    
    
    // MARK: - Life Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpConstraints()
        addPlusButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBManager.shared.getCurrencies { currencies in
            Parser.shared.fetchRecord(currencies: currencies) { records in
                DBManager.shared.saveMyRecords(for: records)
                self.generateViewModel(from: records)
            }
        }
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate.

extension MyCurrenciesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case let .titleCell(text):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TitleTableViewCell",
                for: indexPath
            ) as! TitleTableViewCell
            cell.configureCell(with: text)
            return cell
        case let .recordCell(model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecordTableViewCell",
                for: indexPath
            ) as! RecordTableViewCell
            cell.configureCell(witn: model)
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
        
        if case let .recordCell(model) = cellModel {
            openCurrencyDynamic(with: model)
        }
        
    }
    
}

private extension MyCurrenciesViewController {
    
    func generateViewModel(from records: [Record]) {
        var cells: [MyCurrenciesCells] = []
        
        cells.append(.titleCell(text: "Избранные валюты"))
        cells.append(.spacingCell(height: 20))
        records.forEach {
            cells.append(.recordCell(model: $0))
            cells.append(.spacingCell(height: 10))
        }
        
        viewModel = MyCurrenciesViewModel(with: cells, records: records)
        tableView.reloadData()
    }
    
    @objc func didTapOnPlusButton() {
        let vc = UINavigationController(rootViewController: CurrencyViewConroller())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func openCurrencyDynamic(with model: Record) {
        let viewController = CurrencyDynamicViewController()
        viewController.record = model
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


// MARK: - Constraints.

private extension MyCurrenciesViewController {
    
    func setUpConstraints() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func addPlusButton() {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor(red: 45/255, green: 175/255, blue: 105/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTapOnPlusButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
}
