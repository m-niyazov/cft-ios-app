//
//  SceneDelegate.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 11.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coreDataManager = CoreDataManager()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene =  windowScene
        let navigationVC = UINavigationController(rootViewController: MainScreenVC(coreDataManager: coreDataManager))
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
//        UserDefaults.standard.removeObject(forKey: "isFirstOpen")
        firstOpeningApp()
    }
    
    func firstOpeningApp() {
        let isFirstOpen = UserDefaults.standard.string(forKey: "isFirstOpen")
        if (isFirstOpen == nil) {
            coreDataManager.newNoteInStore(
                title: "Тестовое задание – iOS. Focus Start",
                mainText: """

            Привет тому, кто запустил приложение. Это моё тестовое задание на позицию IOS стажировки в компании ЦФТ.

            Если хотите узнать поддробней о приложений и примененных технологиях в ней, переходите на мой гитхаб - https://github.com/m-niyazov/improve-ad-avito

            Ну, а если вы из компании ЦФТ, значит вы увидели оставленнную мной заявку. Уведомите пожалуйста об том меня в ТГ- https://t.me/m_niyazov. Это нужно, что бы я знал, что моя заявка и данное ТЗ просмотрена.

            Спасибо!)
            """) {
                UserDefaults.standard.set("No", forKey: "isFirstOpen")
            }
        }
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataManager.saveContext()
    }
    
    
}
