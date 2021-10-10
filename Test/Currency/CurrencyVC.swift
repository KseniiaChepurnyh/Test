//
//  CurrencyVC.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit

class CurrencyVC: UIViewController {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CurrencyTableViewCell")
        return tableView
    }()
    
    private var currencyArray: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        CurrencyManager.shared.fetchCurrencyList { currencyArray in
            self.currencyArray = currencyArray
            self.tableView.reloadData()
        }
    }
    
}

extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        cell.configureCell(witn: currencyArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
