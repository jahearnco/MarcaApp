//
//  AppDelegate.swift
//  MarcaApp
//
//  Created by Enjoy on 12/8/22.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    let emptyStr:String = ""
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            /*
        do {
            
            Amplify.Logging.logLevel = .error
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
            print("Amplify configured with auth plugin")

        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
             */
        return true
    }
}
                
