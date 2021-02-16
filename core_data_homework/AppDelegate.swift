//
//  AppDelegate.swift
//  core_data_homework
//
//  Created by Андрей Груненков on 16.02.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataManager = CoreDataManager(modelName: "PlayersCoreDataModels")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Player", bundle: Bundle.main)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as? MainViewController else {
            return false
        }
        mainViewController.dataManager = dataManager
        fillClubsIfEmpty()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
        return true
    }
    
    private func fillClubsIfEmpty() {
        let clubs = dataManager.fetchData(for: Club.self)
        if clubs.count == 0 {
            let context = dataManager.getContext()
            let club1 = dataManager.createObject(from: Club.self)
            club1.name = "Zenit"
            let club2 = dataManager.createObject(from: Club.self)
            club2.name = "Spartak"
            let club3 = dataManager.createObject(from: Club.self)
            club3.name = "Lokomotiv"
            dataManager.save(context: context)
        }
    }

}

