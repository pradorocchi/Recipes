import Foundation

struct Config: Decodable {
    var base = ""
    var space = ""
    var token = ""
    
    var entries: URL { URL(string: base + space + "/entries?access_token" + token)! }
}
