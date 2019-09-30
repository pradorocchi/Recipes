import UIKit
import SwiftUI

final class Scene: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var config = Config()
    private var assets = [Recipes.Assets]()
    private let result = Result()
    private let queue = DispatchQueue(label: "", qos: .background, target: .global(qos: .background))

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
        queue.async {
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
        assets = recipes.includes.Asset
        DispatchQueue.main.async {
            self.result.loading = false
            self.result.entries = recipes.includes.Entry
            self.result.recipes = recipes.items
        }
        download()
    }
    
    private func error(_ error: Error) {
        DispatchQueue.main.async {
            self.result.loading = false
            self.result.error = error
        }
    }
    
    private func download() {
        guard let image = assets.popLast(), let url = URL(string: "https:" + image.fields.file.url) else { return }
        queue.async {
            URLSession.shared.downloadTask(with: url) {
                if $2 == nil, let url = $0, let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.result.images[image.sys.id] = data
                    }
                }
                self.download()
            }.resume()
        }
    }
}
