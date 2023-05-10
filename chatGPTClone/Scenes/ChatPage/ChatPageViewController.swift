//
//  ChatPageViewController.swift
//  chatGPTClone
//
//  Created by Ertürk Alan on 27.04.2023.
//

import Foundation
import UIKit

class ChatPageViewController: UIViewController {
    
    private var messageArray: [Message] = []
    
    //UI
    private let messageBox = UITextField()
    private let sendButton = UIButton()
    private var chatTable: UITableView!
    private let activityIndicator = UIActivityIndicatorView()
    
    //viewModel
    private let viewModel: ChatPageViewModel
    
    init(viewModel: ChatPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        uiConfigure()
        viewModel.delegate = self
        viewModel.updateTitle()
        chatTable.estimatedRowHeight = 46.0
        chatTable.rowHeight = UITableView.automaticDimension
    }

    private func uiConfigure() {
        
        //TextField
        messageBox.placeholder = K.textPlaceholder
        messageBox.font = UIFont.systemFont(ofSize: 16)
        messageBox.borderStyle = UITextField.BorderStyle.roundedRect
        messageBox.autocorrectionType = UITextAutocorrectionType.no
        messageBox.keyboardType = UIKeyboardType.webSearch
        messageBox.returnKeyType = UIReturnKeyType.done
        messageBox.clearButtonMode = UITextField.ViewMode.whileEditing
        messageBox.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        messageBox.delegate = self
        
        //Send Button
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .black
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: nil, size: CGSize(width: 32, height: 32))
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.distribution = .fillProportionally
        
        
        hStackView.addArrangedSubview(messageBox)
        hStackView.addArrangedSubview(sendButton)
        view.addSubview(hStackView)
        
        hStackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, padding: Metrics.Padding.textField, size: Metrics.Size.textField)
        
        //tableView
        chatTable = UITableView()
        chatTable.register(ChatPageCell.self, forCellReuseIdentifier: ChatPageCell.reuseIdentifier)
        chatTable.dataSource = self
        chatTable.delegate = self
        view.addSubview(chatTable)
        chatTable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom:hStackView.topAnchor, right: view.rightAnchor)
        
        //activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.anchorWithCenter(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        activityIndicator.hidesWhenStopped = true
    }
    
    //Send button pressed
    @objc func sendButtonPressed(sender: UIButton!) {
        messageBox.endEditing(true)
    }
    
    fileprivate func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.medium;
        view.addSubview(activityIndicator);

        activityIndicator.startAnimating();
        view.isUserInteractionEnabled = false
    }

    fileprivate func stopLoading(){
        activityIndicator.stopAnimating();
        view.isUserInteractionEnabled = true
    }
    
}
//MARK: - Table View Delegate

extension ChatPageViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messageArray.count)
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatPageCell.reuseIdentifier, for: indexPath) as? ChatPageCell else { return UITableViewCell() }
           
           let message = messageArray[indexPath.row]
           cell.updateCell(message)
          
           return cell
    }
    
   
    
    
}
//MARK: - ChatPageViewModel Delegate Method

extension ChatPageViewController: ChatPageViewModelDelegate {
    func handleViewModelOutput(_ output: ChatPageViewModelOutput) {
        switch output {
        case .showTitle(let title):
            self.navigationItem.title = title
        case .showResponse(let response):
            let message = Message(text: response, isRobot: true)
            self.messageArray.append(message)
            DispatchQueue.main.async {
                self.chatTable.reloadData()
                self.chatTable.scrollToBottom()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - UISearchBar Delegate Method
extension ChatPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageBox.endEditing(true)
          return true
      }
    
      func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          if textField.text != "" {
              return true
          }else{
              textField.placeholder = "Chat with me"
              return false
          }
      }
      
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text{
            let message = Message(text: text, isRobot: false)
            messageArray.append(message)
            chatTable.reloadData()
            chatTable.scrollToBottom()
            viewModel.sendMessage(prompt: text)
            activityIndicator.startAnimating()
        }
        textField.text = ""
        
    }
}



fileprivate struct Metrics {
    struct Padding {
        static let textField: UIEdgeInsets = .init(top: 0, left: 12, bottom: -16, right: -12)
    }
    
    struct Size {
        static let textField: CGSize = .init(width: 0, height: 40)
    }
}
