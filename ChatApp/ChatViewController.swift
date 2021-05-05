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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
        
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        tableView.addGestureRecognizer(tapOnTableView)
    
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
}
extension ChatViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint.constant = 50 + 250
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        containerViewHeightConstraint.constant = 50
    }
}

