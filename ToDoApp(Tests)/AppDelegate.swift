//
//  AppDelegate.swift
//  ToDoApp(Tests)
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    #if targetEnvironment(simulator)
        if CommandLine.arguments.contains("--UITesting") {
            resetState()
        }
    #endif
        return true
    }

    private func resetState() {
        
    #if targetEnvironment(simulator)
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let url = URL(string: "\(documentPath)tasks.plist") else { return}
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: url)
        
    #endif
        
    }
}

