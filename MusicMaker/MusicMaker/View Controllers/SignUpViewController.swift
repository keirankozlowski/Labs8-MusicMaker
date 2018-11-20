//
//  SignUpViewController.swift
//  MusicMaker
//
//  Created by Vuk Radosavljevic on 11/7/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController {

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissKeyboardGestureRecognizer()
 
    }
    
    //Adds an observer to listen for the keyboardWillShowNotification & keyboardWillHideNotifcation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    //Removes the observer for the keyboardWillShowNotification & keyboardWillHideNotifcation
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    // MARK: - Private
    
    //Used to move the views frame up when the keyboard is about to be shown so the textfields can be seen
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 10)
            }
        }
    }
    
    //Used to move the views frame back to the normal position when the keyboard goes away
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 10)
            }
        }
    }
    
    //Adds a gesture recognizer that calls dismissKeyboard(_:)
    private func addDismissKeyboardGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //Resigns the first responder for the textField when clicking away from the keyboard
    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.delegate = self
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            lastNameTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            confirmPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var selectLevelTextField: UITextField! {
        didSet {
            selectLevelTextField.delegate = self
        }
    }
        
    @IBOutlet weak var selectInstrumentTextField: UITextField! {
        didSet {
            selectInstrumentTextField.delegate = self
        }
    }
    

    
    // MARK: - IBActions
    
    @IBAction func selectLevel(_ sender: UITextField) {
        presentLevelAlertController(on: sender)
    }
   
    @IBAction func selectInstrument(_ sender: UITextField) {
        presentInstrumentAlertController(on: sender)
    }
    
    private func presentLevelAlertController(on textField: UITextField) {
        let beginnerAction = UIAlertAction(title: "Beginner", style: .default) { (action) in
            textField.text = "Beginner"
        }
        
        let intermediateAction = UIAlertAction(title: "Intermediate", style: .default) { (action) in
            textField.text = "Intermediate"
        }
        
        let expertAction = UIAlertAction(title: "Expert", style: .default) { (action) in
            textField.text = "Expert"
        }
        
        let alert = UIAlertController(title: "Select your level of experience", message: "", preferredStyle: .actionSheet)
        alert.addAction(beginnerAction)
        alert.addAction(intermediateAction)
        alert.addAction(expertAction)
        
        //Used if its an ipad to present as a popover
        let popover = alert.popoverPresentationController
        popover?.permittedArrowDirections = .down
        popover?.sourceView = textField
        popover?.sourceRect = textField.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentInstrumentAlertController(on textField: UITextField) {
        let trumpetAction = UIAlertAction(title: "Trumpet", style: .default) { (action) in
            textField.text = "Trumpet"
        }
        
        let fluteAction = UIAlertAction(title: "Flute", style: .default) { (action) in
            textField.text = "Flute"
        }
        
        let violinAction = UIAlertAction(title: "Violin", style: .default) { (action) in
            textField.text = "Violin"
        }
        
        let alert = UIAlertController(title: "Select Your Instrument", message: "", preferredStyle: .actionSheet)
        alert.addAction(trumpetAction)
        alert.addAction(fluteAction)
        alert.addAction(violinAction)
        
        //Used if its an ipad to present as a popover
        let popover = alert.popoverPresentationController
        popover?.permittedArrowDirections = .down
        popover?.sourceView = textField
        popover?.sourceRect = textField.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // Used to toggle the password textfields to show or hide entry
    @IBAction func toggleSecureEntryOnPasswordTextFields(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if passwordTextField.isSecureTextEntry == false {
                passwordTextField.isSecureTextEntry = true
            } else {
                passwordTextField.isSecureTextEntry = false
            }
        case 1:
            if confirmPasswordTextField.isSecureTextEntry == false {
                confirmPasswordTextField.isSecureTextEntry = true
            } else {
                confirmPasswordTextField.isSecureTextEntry = false
            }
        default:
            break
        }
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let confirmedPassword = confirmPasswordTextField.text,
            let instrument = selectInstrumentTextField.text,
            let level = selectLevelTextField.text
        else {return}
        
        guard password == confirmedPassword else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            //Error creating user checks different errors and updates UI to let user know why there was an error
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .weakPassword:
                        print("weakPassword")
                    case .accountExistsWithDifferentCredential:
                        print("Account already exisits")
                    case .emailAlreadyInUse:
                        print("email in use")
                    case .invalidEmail:
                        print("invalid email")
                    case .missingEmail:
                        print("missing email")
                    default:
                        print("error")
                    }
                }
            }
            
            let database = Firestore.firestore()
            
            let userDocumentInformation = ["email" : email, "firstName": firstName, "lastName" : lastName, "instrument": instrument, "level": level]
            
            if let user = user {
                let usersUniqueIdentifier = user.user.uid
                database.collection("students").document(usersUniqueIdentifier).collection("settings").addDocument(data: userDocumentInformation)
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    //Makes the next textfield the first responder when filling out sign in
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            lastNameTextField.becomeFirstResponder()
        case 1:
            emailTextField.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
        case 3:
            confirmPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    //Disables keyboard on select level textfield since their are three options to
    //choose from
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 5 || textField.tag == 6 {
            return false
        }
        return true
    }
    
    
    
}
