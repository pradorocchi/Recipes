import UIKit
import SwiftUI

final class Scene: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var config = Config()
    private let result = Result()

    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let content = Content(result: result, refresh: refresh)
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = UIHostingController(rootView: content)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        do {
            config = try JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Config", withExtension: "json")!))
            refresh()
        } catch {
            result.error = error
        }
    }
    
    private func refresh() {
        result.error = nil
        result.loading = true
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: self.config.recipes) {
                if let error = $2 {
                    self.error(error)
                } else if let data = $0 {
                    do {
                        try self.recipes(JSONDecoder().decode(Recipes.self, from: data))
                    } catch {
                        self.error(error)
                    }
                } else {
                    self.error(NSError(domain: NSLocalizedString("Error.empty", comment: ""), code: 0))
                }
            }.resume()
        }
    }
    
    private func recipes(_ recipes: Recipes) {
        DispatchQueue.main.async {
            self.result.loading = false
            self.result.recipes = recipes.items
        }
    }
    
    private func error(_ error: Error) {
        DispatchQueue.main.async {
            self.result.loading = false
            self.result.error = error
        }
    }
}
