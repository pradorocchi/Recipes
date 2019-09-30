import UIKit
import SwiftUI

struct E: LocalizedError {
    
}

final class Scene: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var config = Config()
    private let result = Result()

    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let content = Content(result: result)
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = UIHostingController(rootView: content)
        window.makeKeyAndVisible()
        self.window = window
        print("this")
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        do {
            config = try JSONDecoder().decode(Config.self, from: Data(contentsOf: Bundle.main.url(forResource: "Config", withExtension: "json")!))
        } catch {
            result.error = error
        }
    }
}
