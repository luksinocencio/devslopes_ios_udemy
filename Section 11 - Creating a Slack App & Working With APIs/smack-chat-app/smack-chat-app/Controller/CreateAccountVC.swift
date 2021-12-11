import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - VARIABLES
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTapAround()
        self.tfUsername.becomeFirstResponder()
        
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           if UserDataService.instance.avatarName != "" {
               userImageView.image = UIImage(named: UserDataService.instance.avatarName)
               avatarName = UserDataService.instance.avatarName
            print("avatarName: \(avatarName)")
               if avatarName.contains("light") && bgColor == nil {
                   userImageView.backgroundColor = UIColor.lightGray
               }
           }
       }
    
    // MARK: - Methods
    
    func setupView() {
        spinner.isHidden = true
        tfUsername.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        tfEmail.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        tfPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColor(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImageView.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let name = tfUsername.text, tfUsername.text != "" else {
            return
        }
        
        guard let email = tfEmail.text, tfEmail.text != "" else {
            return
        }
        
        guard let password = tfPassword.text, tfPassword.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password) { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            if success {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
