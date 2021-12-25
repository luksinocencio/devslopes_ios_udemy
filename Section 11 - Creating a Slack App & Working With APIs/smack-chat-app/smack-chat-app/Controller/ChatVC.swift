import UIKit

class ChatVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var lbChannelName: UILabel!
    @IBOutlet weak var tfMessageBox: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupNotification()
        checkEmail()
        getMessage()
        hideKeyboardOnTapAround()
        view.bindToKeyboard()
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
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.lbChannelName.text = "No channels yet!"
                }
            }
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        lbChannelName.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { success in
            print("Olha aqui")
        }
    }
    
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
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
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?._id else { return }
            guard let message = tfMessageBox.text else { return }
            let userId = UserDataService.instance.id
                    
            SocketService.instance.addMessage(messageBody: message, userId: userId, channelId: channelId) { success in
                if success {
                    self.tfMessageBox.text = ""
                    self.tfMessageBox.resignFirstResponder()
                }
            }
        }
    }
    
}
