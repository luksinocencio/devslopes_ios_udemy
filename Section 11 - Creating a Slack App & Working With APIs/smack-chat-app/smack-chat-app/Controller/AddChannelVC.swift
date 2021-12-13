import UIKit

class AddChannelVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var tfChannelName: UITextField!
    @IBOutlet weak var tfChannelDescription: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTf()
    }

    // MARK: - IBAction
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = tfChannelName.text, tfChannelName.text != "" else { return }
        guard let channelDesc = tfChannelDescription.text, tfChannelDescription.text != "" else { return }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Methods
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    func setupTf() {
        tfChannelName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        tfChannelDescription.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    // MARK: - Selectors
    
    @objc
    func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
