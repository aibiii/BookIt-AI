import Foundation
struct LikedMessage: Codable, Identifiable {
    var id: String // Make sure the 'id' property is of type 'String' or 'DocumentID'
    var content: String // Add other properties if needed
    var dateLiked: Date
}
