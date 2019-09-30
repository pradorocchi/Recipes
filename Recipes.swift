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
    
    struct Asset: Decodable {
        struct Fields: Decodable {
            var file = File()
        }
        
        struct File: Decodable {
            var url = ""
        }
        
        let sys = Sys()
        var fields = Fields()
    }
    
    struct Sys: Decodable, Hashable {
        var id = ""
    }
    
    var items = [Item]()
    var includes = [Asset]()
}
