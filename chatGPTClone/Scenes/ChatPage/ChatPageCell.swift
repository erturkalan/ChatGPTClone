//
//  ChatPageCell.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 2.05.2023.
//

import UIKit

class ChatPageCell: UITableViewCell {
    
    static let reuseIdentifier = "ChatPageCell"
    
    let label = UILabel()
    private let cellView = UIView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellUI() {
        //configure view
        contentView.addSubview(cellView)
        cellView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        
        //configure title label
        cellView.addSubview(label)
        label.anchor(top: cellView.topAnchor, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: cellView.rightAnchor, padding: UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    func updateCell(_ messageModel: Message) {
        cellView.backgroundColor = messageModel.isRobot ? .gray : .white
        label.textColor = messageModel.isRobot ? .white : .black
        label.text = messageModel.text
    }
}
