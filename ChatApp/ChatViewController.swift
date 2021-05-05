//
//  ChatViewController.swift
//  ChatApp
//
//  Created by KDD on 06.05.2021.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    private let messagesDB = Database.database().reference().child("Messages")
    private var messages: [MessageEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
        
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        tableView.addGestureRecognizer(tapOnTableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MessageCell.id, bundle: Bundle(for: MessageCell.self)), forCellReuseIdentifier: MessageCell.id)
        
        fetchMessagesFromFirebase()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        let openImage = UIImagePickerController()
                openImage.sourceType = .photoLibrary
                openImage.delegate = self
                openImage.allowsEditing = true
                present(openImage, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendMessagesToFirebase()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatViewController{
    
    @objc private func tappedOnTableView(){
        inputTextField.endEditing(true)
    }
    
    private func sendMessagesToFirebase(){
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let message = inputTextField.text else { return }
        let messagesDict = ["sender": email, "message": message]
        sendButton.isEnabled = false
        inputTextField.text = ""
        
        messagesDB.childByAutoId().setValue(messagesDict) { [weak self](error, reference ) in
            if error != nil {
                print("Failed to sent message, \(error!)")
            }
            else {
                self?.sendButton.isEnabled = true
            }
        }
    }
    
    private func fetchMessagesFromFirebase(){
        messagesDB.observe(.childAdded) { [weak self](snapshot) in
            if let values = snapshot.value as? [String: String] {
                guard let message = values["message"] else { return }
                guard let sender = values["sender"] else { return }
                self?.messages.append(MessageEntity(message: message, sender: sender))
                self?.tableView.reloadData()
                self?.scrollToLastMessage()
                
            }
        }
    }
    
    private func scrollToLastMessage(){
        if messages.count - 1 > 0 {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint.constant = 50 + 250
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.id, for: indexPath) as!
        MessageCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
}

