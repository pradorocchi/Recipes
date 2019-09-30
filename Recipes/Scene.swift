import UIKit
import SwiftUI

final class Scene: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let content = Content()
        if let scene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            window.rootViewController = UIHostingController(rootView: content)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
