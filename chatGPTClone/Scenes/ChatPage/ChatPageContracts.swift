//
//  ChatPageContracts.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 27.04.2023.
//

import Foundation


protocol ChatPageViewModelProtocol {
    var delegate: ChatPageViewModelDelegate? { get set }
    func updateTitle()
    func sendMessage(prompt: String)
}

enum ChatPageViewModelOutput {
    case showTitle(String)
    case showResponse(String)
}

protocol ChatPageViewModelDelegate: AnyObject {
    func handleViewModelOutput (_ output: ChatPageViewModelOutput)
}
