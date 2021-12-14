import Alamofire
import Foundation

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        AF.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                self.setMessage(data: data)
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                completion(true)
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            }
        }
    }
    
    func setMessage(data: Data) {
        let decoder = JSONDecoder()
        guard let channel = try? decoder.decode([Channel].self, from: data) else { return }
        channels = channel
    }
    
    func clearChannels() {
        channels.removeAll()
    }
}
