//
//  MainViewController.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import UIKit
import SnapKit



class MainViewController: UIViewController {
    
    private var records: [Record] = []
    
    private let endDate: String = {
        let date = Date()
        return Date().fogmatedDate(date: date)
    }()
    
    private let startDate: String = {
        let date = Date()
        guard let endDate = Calendar.current.date(byAdding: .day, value: -30, to: date) else { return "01/01/2021"}
        return Date().fogmatedDate(date: endDate)
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Курс Доллара США (USD)"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 20)!]
        
        Parser.shared.fetchRecords(startDate: startDate, endDate: endDate) { records in
            self.records = records
            self.tableView.reloadData()
        }
        
        setUpConstraints()
        
        if Value.savedValue == 0.0 {
            configureAllert()
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let difference = records[indexPath.row].value - records[indexPath.row + 1].value
        cell.configureCell(with: .init(value: String(records[indexPath.row].value), date: records[indexPath.row].date, difference: String(difference)))
//        cell.titleLabel.text = String(records[indexPath.row].value)
//        cell.subtitleLabel.text = records[indexPath.row].date
//
//        if records[indexPath.row].date != records.last!.date {
//            let difference = records[indexPath.row].value - records[indexPath.row + 1].value
//            if records[indexPath.row].value < records[indexPath.row + 1].value {
//                cell.arrowImage.image = UIImage(systemName: "arrow.down")
//                cell.arrowImage.tintColor = .systemRed
//                cell.differenceLabel.text = String(format: "%.3f", difference)
//
//            } else {
//                cell.arrowImage.image = UIImage(systemName: "arrow.up")
//                cell.arrowImage.tintColor = .systemGreen
//                cell.differenceLabel.text = "+" + String(format: "%.3f", difference)
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

private extension MainViewController {
    
    func configureAllert() {
        let alert = UIAlertController(title: "", message: "Укажите курс доллара, при котором хотели бы получить уведомление", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "75.50"
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            textField?.keyboardType = .numbersAndPunctuation
            guard let value = Float(textField?.text ?? "0.0") else { return }
            Value.savedValue = value
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpConstraints() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

}
