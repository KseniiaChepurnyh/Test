//
//  SceneDelegate.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        DBManager.shared.getCurrencies { currencies in
            if currencies.count != 0 {
                self.window?.rootViewController = UINavigationController(rootViewController: MyCurrenciesViewController())
            } else {
                self.window?.rootViewController = UINavigationController(rootViewController: CurrencyViewConroller())
            }
        }
    }


    func sceneDidEnterBackground(_ scene: UIScene) {
        print("App Was Backgrounded")
        (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundFetch()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

