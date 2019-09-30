import Foundation

final class Result: ObservableObject {
    @Published var error: Error?
    @Published var loading = false
    @Published var recipes = [Recipes.Item]()
}

struct Recipes: Decodable {
    struct Fields: Decodable, Hashable {
        var title = ""
    }
    
    struct Item: Hashable, Decodable {
        var fields = Fields()
    }
    
    let items: [Item]
}
