import Foundation

struct Message: Codable {
    public private(set) var message: String!
    public private(set) var userName: String!
    public private(set) var channelId: String!
    public private(set) var userAvatar: String!
    public private(set) var userAvatarColor: String!
    public private(set) var _id: String!
    public private(set) var timeStamp: String!
}
