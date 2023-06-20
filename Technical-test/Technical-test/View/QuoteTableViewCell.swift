//
//  QuoteTableViewCell.swift
//  Technical-test
//
//  Created by Vladyslav Poznyak on 20.06.2023.
//

import UIKit

final class QuoteTableViewCell: UITableViewCell {
    static let reuseId = "com.technical-test.quoteTableCellId"
    var quote: Quote? {
        didSet {
            updateQuote()
        }
    }
    
    private let nameLabel = UILabel()
    private let lastLabel = UILabel()
    private let readableLastChangePercentLabel = UILabel()
    private let favouriteImageView = UIImageView(
        image: UIImage(named: Assets.notFavourite.rawValue),
        highlightedImage: UIImage(named: Assets.favorite.rawValue))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
}

private extension QuoteTableViewCell {
    func setupSubviews() {
        nameLabel.font = .systemFont(ofSize: 10)
        lastLabel.font = .systemFont(ofSize: 10)
        readableLastChangePercentLabel.font = .systemFont(ofSize: 17)
        
        let leadingStack = UIStackView()
        leadingStack.axis = .vertical
        leadingStack.alignment = .leading
        leadingStack.distribution = .fillEqually
        leadingStack.spacing = 4
        leadingStack.addArrangedSubview(nameLabel)
        leadingStack.addArrangedSubview(lastLabel)
        
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.spacing = 8
        mainStack.addArrangedSubview(leadingStack)
        mainStack.addArrangedSubview(readableLastChangePercentLabel)
        mainStack.addArrangedSubview(favouriteImageView)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 8)
        ])
    }
    
    func updateQuote() {
        nameLabel.text = quote?.name
        lastLabel.text = [quote?.last, quote?.currency].compactMap {
            $0
        }.joined(separator: " ")
        readableLastChangePercentLabel.text = quote?.readableLastChangePercent
        readableLastChangePercentLabel.textColor = quote?.readableLastChangeColor
        //TODO: favorite
    }
}

private extension Quote {
    var readableLastChangeColor: UIColor? {
        switch variationColor {
        case .red:
            return .red
        case .green:
            return .green
        default:
            return nil
        }
    }
}
