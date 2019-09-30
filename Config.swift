import Foundation

struct Config: Decodable {
    var base = ""
    var space = ""
    var token = ""
    
    var recipes: URL { URL(string: base + space + "/entries?access_token=" + token + "&content_type=recipe")! }
    
//    func asset(_ for: Recipes.Item) -> URL {
//        URL(string: base + space + "/assets/?access_token=" + token + "&content_type=recipe")!
//        https://cdn.contentful.com/spaces/kk2bw5ojx476/assets/5mFyTozvSoyE0Mqseoos86?access_token=7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c&content_type=recipe
//    }
}
