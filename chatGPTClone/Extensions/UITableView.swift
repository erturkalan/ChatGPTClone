//
//  UITableView.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 9.05.2023.
//

import Foundation
import UIKit


extension UITableView {
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections-1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
