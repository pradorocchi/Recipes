import Foundation

final class Result: ObservableObject {
    @Published var error: Error?
    @Published var loading = false
    @Published var recipes = [Recipes.Item]()
    @Published var images = [String: Data]()
}
