import Foundation

struct Recipes: Decodable {
    struct Item: Hashable, Decodable {
        struct Fields: Decodable, Hashable {
            var title = ""
            var description = ""
            var photo = Photo()
            var chef: Chef?
        }
        
        struct Photo: Decodable, Hashable {
            var sys = Sys()
        }
        
        struct Chef: Decodable, Hashable {
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
