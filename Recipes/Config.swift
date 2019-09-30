import Foundation

struct Config: Decodable {
    var base = ""
    var space = ""
    var token = ""
    
    var recipes: URL { URL(string: base + space + "/entries?access_token=" + token + "&content_type=recipe")! }
}
