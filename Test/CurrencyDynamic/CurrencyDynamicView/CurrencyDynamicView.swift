//
//  CurrencyDynamicView.swift
//  Test
//
//  Created by Ксения Чепурных on 13.10.2021.
//

import UIKit

// MARK: - View Model.

struct CurrencyDynamicDetailViewModel {
    let records: [Record]
    let cells: [CurrencyDynamicDetailCells]
    
    init(with cells: [CurrencyDynamicDetailCells] = [], records: [Record] = []) {
        self.records = records
        self.cells = cells
    }
}

enum CurrencyDynamicDetailCells {
    case headerCell
    case recordCell(model: Record)
}

final class CurrencyDynamicView: UIView {
    
    // MARK: - UI Properties.

    private lazy var tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
         tableView.delegate = self
         tableView.dataSource = self
         tableView.showsVerticalScrollIndicator = false
         tableView.separatorStyle = .none
         tableView.register(
            CurrencyDynamicHeaderTableViewCell.self,
             forCellReuseIdentifier: "CurrencyDynamicHeaderTableViewCell"
         )
         tableView.register(
            CurrencyDynamicRecordTableViewCell.self,
             forCellReuseIdentifier: "CurrencyDynamicRecordTableViewCell"
         )
        tableView.layer.cornerRadius = 12
         return tableView
    }()
    
    
    // MARK: - Properties.
    
    private var viewModel: CurrencyDynamicDetailViewModel?
    
    
    // MARK: - Initialization.
    
    init(with records: [Record]) {
        super.init(frame: .zero)
        
        generateViewModel(from: records)
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}


// MARK: - UITableViewDataSource & UITableViewDelegate.

extension CurrencyDynamicView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cells[indexPath.row]
        
        switch cellModel {
        case .headerCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrencyDynamicHeaderTableViewCell",
                for: indexPath
            ) as! CurrencyDynamicHeaderTableViewCell
            return cell
        case let .recordCell(model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrencyDynamicRecordTableViewCell",
                for: indexPath
            ) as! CurrencyDynamicRecordTableViewCell
            cell.configureCell(with: model)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}


// MARK: - Private Methods.

private extension CurrencyDynamicView {
    
    func generateViewModel(from records: [Record]) {
        var cells: [CurrencyDynamicDetailCells] = []
        
        cells.append(.headerCell)
        records.forEach { record in
            cells.append(.recordCell(model: record))
        }
        
        viewModel = CurrencyDynamicDetailViewModel(with: cells, records: records)
        tableView.reloadData()
    }
}

// MARK: - Constraints.

private extension CurrencyDynamicView {
    
    func setUpConstraints() {
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
