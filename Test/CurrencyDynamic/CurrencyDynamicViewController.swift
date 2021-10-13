//
//  MainViewController.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import UIKit

struct CurrencyDynamicViewModel {
    let records: [Record]
    let cells: [CurrencyDynamicCells]
    
    init(with cells: [CurrencyDynamicCells] = [], records: [Record]) {
        self.records = records
        self.cells = cells
    }
}

enum CurrencyDynamicCells {
    case recordsDynamicCells(model: [Record])
}


final class CurrencyDynamicViewController: UIViewController {
    
    // MARK: - UI Properties.
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(
            CurrencyDynamicTableViewCell.self,
            forCellReuseIdentifier: "CurrencyDynamicTableViewCell"
        )
        tableView.backgroundColor = UIColor(
            red: 240/255,
            green: 240/255,
            blue: 245/255,
            alpha: 1
        )
        return tableView
    }()
    
    
    // MARK: - Properties.
    
    private var viewModel: CurrencyDynamicViewModel?
    var record: Record?

    
    // MARK: - Life Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let record = record else { return }
        
        title = "\(record.name)"
        
        addNavigationBackButton()
        getDailyRecords(for: record)
        setUpConstraints()
    }
    
}


// MARK: - UITableViewDataSource & UITableViewDelegate.

extension CurrencyDynamicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case let .recordsDynamicCells(model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrencyDynamicTableViewCell",
                for: indexPath
            ) as! CurrencyDynamicTableViewCell
            cell.configureCell(with: model)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
}


// MARK: - Private Methods.

private extension CurrencyDynamicViewController {
    
    func generateViewModel(from records: [Record]) {
        var cells: [CurrencyDynamicCells] = []
        
        cells.append(.recordsDynamicCells(model: records))
        
        
        viewModel = CurrencyDynamicViewModel(with: cells, records: records)
        tableView.reloadData()
    }
    
    func getDailyRecords(for record: Record) {
        let endDate = Date().string()
        let startDate = Date().monthFromNowDate().string()
        
        Parser.shared.fetchRecords(startDate: startDate, endDate: endDate, code: record.id) { records in
            self.generateViewModel(from: records)
        }
    }
    
    @objc func didTapOnBackButton() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
}


// MARK: - Constraints.

private extension CurrencyDynamicViewController {
    
    func setUpConstraints() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func addNavigationBackButton() {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

}
