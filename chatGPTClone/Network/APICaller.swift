//
//  APICaller.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 8.05.2023.
//

import OpenAISwift
import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private var client : OpenAISwift?
    
    typealias MessageCompletion = (String) -> Void
    
    private init(){}
    
    public func setup() {
        self.client = OpenAISwift(authToken: K.Api.apiKey)
    }
    
    public func getResponse(chatMessageModel: [ChatMessage], completion: @escaping MessageCompletion) {
        
            self.client?.sendChat(with: chatMessageModel,completionHandler: {
                [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let model):
                    if let message = model.choices?.first?.message.content {
                        completion(message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
