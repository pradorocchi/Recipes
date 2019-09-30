import Foundation

struct Recipes: Decodable {
    struct Item: Hashable, Decodable {
        struct Fields: Decodable, Hashable {
            var photo = Photo()
            var tags: [Tag]?
            var chef: Chef?
            var title = ""
            var description = ""
        }
        
        struct Photo: Decodable, Hashable {
            var sys = Sys()
        }
        
        struct Chef: Decodable, Hashable {
            var sys = Sys()
        }
        
        struct Tag: Decodable, Hashable {
            var sys = Sys()
        }
        
        var fields = Fields()
    }
    
    struct Includes: Decodable {
        var Asset = [Assets]()
        var Entry = [Entries]()
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
    
    struct Entries: Decodable {
        struct Fields: Decodable {
            var name = ""
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
