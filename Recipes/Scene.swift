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
        result.loading = true
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: .init(url: self.config.recipes, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 9)) {
                if let error = $2 {
                    DispatchQueue.main.async {
                        self.result.error = error
                    }
                } else if let data = $0 {
                    do {
                        let recipes = try JSONDecoder().decode(Recipes.self, from: data)
                        DispatchQueue.main.async {
                            self.result.loading = false
                            self.result.recipes = recipes.items
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.result.error = error
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.result.error = NSError(domain: NSLocalizedString("Error.empty", comment: ""), code: 0)
                    }
                }
            }.resume()
        }
    }
}
