import Foundation

struct Recipes: Decodable {
    struct Item: Hashable, Decodable {
        struct Fields: Decodable, Hashable {
            var title = ""
            var photo = Photo()
        }
        
        struct Photo: Decodable, Hashable {
            var sys = Sys()
        }
        
        var fields = Fields()
    }
    
    struct Includes: Decodable {
        var Asset = [Assets]()
    }
    
    struct Assets: Decodable {
        struct Fields: Decodable {
            var file = File()
        }
        
        struct File: Decodable {
            var url = ""
        }
        
        var sys = Sys()
        var fields = Fields()
    }
    
    struct Sys: Decodable, Hashable {
        var id = ""
    }
    
    var items = [Item]()
    var includes = Includes()
}
