import Foundation
import Alamofire

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get  {
            return defaults.string(forKey: TOKEN_KEY) ?? ""
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get  {
            return defaults.string(forKey: USER_EMAIL) ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let header: HTTPHeaders  = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_REGISTER, method: .post,  parameters: body, encoding: JSONEncoding.default, headers: header).responseString { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                debugPrint(error as Any)
                completion(false)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let header: HTTPHeaders  = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_LOGIN, method: .post,  parameters: body, encoding: JSONEncoding.default, headers: header).responseString { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                guard let user = try? decoder.decode(Auth.self, from: data) else { return }
                self.authToken = user.token
                self.userEmail = user.user
                self.isLoggedIn = true
                completion(true)
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let request = AF.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        request.responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        AF.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            case .failure(let error):
                completion(false)
                debugPrint(error as Any)
            }
        }
    }
    
    func setUserInfo(data: Data) {
        let decoder = JSONDecoder()
        guard let user = try? decoder.decode(User.self, from: data) else { return }
        
        let id = user._id
        let color = user.avatarColor
        let avatarName = user.avatarName
        let email = user.email
        let name = user.name
        
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
}

