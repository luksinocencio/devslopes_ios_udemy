import UIKit

class LoginVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTapAround()
        self.tfEmail.becomeFirstResponder()
        self.setupView()
    }
    
    // MARK: - Methods
    
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func setupView() {
        spinner.isHidden = true
        tfEmail.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        tfPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    // MARK: - Selectors
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = tfEmail.text, tfEmail.text != "" else { return }
        guard let password = tfPassword.text, tfPassword.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { success in
            if success {
                AuthService.instance.findUserByEmail { success in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func createAcctountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
