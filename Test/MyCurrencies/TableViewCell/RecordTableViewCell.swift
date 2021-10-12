//
//  RecordTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 12.10.2021.
//

import UIKit

final class RecordTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties.
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(
            red: 240/255,
            green: 240/255,
            blue: 245/255,
            alpha: 1
        )
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var titleAndValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        contentBackgroundView.addSubview(stackView)
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        titleAndValueStackView.addArrangedSubview(label)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        titleAndValueStackView.addArrangedSubview(label)
        return label
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rightArrowCircle")
        return imageView
    }()
    
    
    // MARK: - Initialization.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Configure Cell.

extension RecordTableViewCell {
    
    func configureCell(witn record: Record) {
        titleLabel.text = record.name
        valueLabel.text = String(format: "%.2f", record.value)
    }
    
}


// MARK: - Constraints.

private extension RecordTableViewCell {
    
    func setUpConstraints() {
        contentBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(90)
        }
        
        contentBackgroundView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentBackgroundView.snp.centerY)
            make.trailing.equalTo(contentBackgroundView).inset(16)
            make.height.width.equalTo(20)
        }
        
        titleAndValueStackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentBackgroundView.snp.centerY)
            make.leading.equalTo(contentBackgroundView).offset(16)
            make.trailing.equalTo(rightArrowImageView).inset(16)
        }
    }
    
}
