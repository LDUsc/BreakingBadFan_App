//
//  ViewController.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

enum SegmentMode {
    case login
    case register
}

import UIKit

final class LoginOrRegisterViewContoller: ParentViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var submitButton: CustomButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    private var availableTextFields: [UITextField] = []
    private var segment: SegmentMode = .login
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureInitialView()
        clearTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureViewForRelog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldDelegates()
    }
    
    // MARK: - IBActions
    
    @IBAction func changeSegmentTapped(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            segment = .login
        case 1:
            segment = .register
        default:
            break
        }
        configureViewForSegment()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        loginOrRegister()
    }
    
}

// MARK: - Login / Register

private extension LoginOrRegisterViewContoller {
    func loginOrRegister() {
        switch segment {
        case .login:
            login()
        case .register:
            register()
        }
    }
    
    func login() {
        do {
            try AccountManager.login(
                username: usernameTextField.text,
                password: passwordTextfield.text
            )
            proceedToHomeView()
        } catch {
            if let error = error as? AccountManagerError {
                presentAlert(title: error.errorDescription, message: "")
            }
        }
    }
    
    
    func register() {
        do {
            try
                AccountManager.registerAccount(
                    username: usernameTextField.text,
                    password: passwordTextfield.text,
                    passwordConfirmation: confirmPasswordTextfield.text
                )
            
            proceedToHomeView()
        } catch {
            if let error = error as? AccountManagerError {
                presentAlert(title: error.errorDescription, message: "")
            }
        }
    }
}

// MARK: - Helpers

private extension LoginOrRegisterViewContoller {
    
    func setTextfieldDelegates() {
        usernameTextField.delegate = self
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
    }
    
    func configureInitialView() {
        segment = .login
        confirmPasswordTextfield.isHidden = true
        submitButton.isAccesible(isAccesible: false)
        availableTextFields = [usernameTextField, passwordTextfield]
    }
    
    func configureSubmitButton() {
        let allTextFieldsFilled = availableTextFields.allSatisfy { textField in
            guard let text = textField.text else { return false }
            return text.isNotEmpty
        }
        submitButton.isAccesible(isAccesible: allTextFieldsFilled)
    }
    
    func configureViewForRelog() {
        if UserDefaultsManager.currentlyLoggedInAccount != nil {
            proceedToHomeView()
        }
    }
    
    func configureViewForSegment() {
        switch segment {
        case .login:
            confirmPasswordTextfield.isHidden = true
            availableTextFields = [usernameTextField, passwordTextfield]
            configureSubmitButton()
        case .register:
            confirmPasswordTextfield.isHidden = false
            availableTextFields = [usernameTextField, passwordTextfield, confirmPasswordTextfield]
            configureSubmitButton()
        }
    }
    
    func clearTextFields() {
        usernameTextField.text = nil
        passwordTextfield.text = nil
        confirmPasswordTextfield.text = nil
    }
}

// MARK: - TextField Delegate Methods

extension LoginOrRegisterViewContoller: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureSubmitButton()
    }
}
