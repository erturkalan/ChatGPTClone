//
//  ChatPageViewModel.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 27.04.2023.
//

import Foundation
import OpenAISwift

class ChatPageViewModel : ChatPageViewModelProtocol {
   
    var delegate: ChatPageViewModelDelegate?
    
    func updateTitle() {
        notify(.showTitle(K.appName))
    }
 
        
    func sendMessage(prompt: String) {
        let chat = [ChatMessage(role: .user, content: prompt)]
        APICaller.shared.getResponse(chatMessageModel: chat) { response in
            self.notify(.showResponse(response))
        }
    }
    
  
    private func notify(_ output: ChatPageViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
}


