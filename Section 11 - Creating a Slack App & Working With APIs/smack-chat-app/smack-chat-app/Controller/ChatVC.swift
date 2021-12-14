import UIKit

class ChatVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var lbChannelName: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupNotification()
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
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { success in
            if success {
                // TODO: - stuff with channels
            }
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        lbChannelName.text = "#\(channelName)"
    }
    
    // MARK: - Selectors
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            lbChannelName.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
}
