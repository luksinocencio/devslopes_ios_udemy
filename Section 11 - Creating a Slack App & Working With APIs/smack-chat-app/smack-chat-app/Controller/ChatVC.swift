import UIKit

class ChatVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var menuBtn: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu()
        checkEmail()
        getMessage()
    }
    
    // MARK: - Methods
    
    func setupSideMenu() {
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func checkEmail() {
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { success in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    func getMessage() {
        if !AuthService.instance.authToken.isEmpty {
            MessageService.instance.findAllChannel { success in }
        }
    }
}
