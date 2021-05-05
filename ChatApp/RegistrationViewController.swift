//
//  RegistrationViewController.swift
//  ChatApp
//
//  Created by KDD on 06.05.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationButton.layer.cornerRadius = 4
        registrationButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self](result, error) in
            if error != nil {
                print(error!)
            }
            else {
                self?.performSegue(withIdentifier: "goToChatFromRegistration", sender: nil)
            }
        }
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
