//
//  MarcaAppApp.swift
//  MarcaApp
//
//  Created by Enjoy on 1/16/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import SwiftUI

@main
final class MarcaAppApp: App {
    init(){
        do{
            Amplify.Logging.logLevel = .error
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
            _D.debug = false
            
            print("Amplify configured with auth plugin")
        }catch{
            print(error)
        }
        
        initCognito()
        initDataModel()
        
        /**
         * if user logged in handled in background thread
         * UI to respond/update asynchronously via model @StateObject
         */
        Task{
            let loggedInUser:AuthUser? = await CognitoProxy.getLoggedInUser()
            await AppInitProxy.handleIfUserLoggedIn(loggedInUser:loggedInUser)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentViewParent()
        }
    }

    /*
     * static Singleton instance: instantiate once/store once
     * after setting here instance is acquired by _M.M()
     */
    private func initDataModel() {
        let model = MarcaClassFactory.getInstance(className:"_M", kType: _M.self, instanceLabel:"modelA") as? _M
        print("model initialized : \(model!.getInstanceLabel()) ")
    }
    
    /*
     * Cognito need not be a class for now. this is for future impls
     * static Singleton instance: instantiate once/store once
     * after setting here instance is acquired via Cognito.getSingletonInstance()
     */
    private func initCognito() {
        let cognito = MarcaClassFactory.getInstance(className:"Cognito", kType: Cognito.self, instanceLabel:"cogA") as? Cognito
        print("cognito initialized : \(cognito!.getInstanceLabel()) ")
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

struct AppInitProxy{
    public static func handleIfUserLoggedIn(loggedInUser:AuthUser?)async{
        let isLoggedIn = loggedInUser != nil
        
        await _M.setMainViewChoice(.loginView)
        await _M.setTaskViewChoice(.logsView)
        await _M.setCacheKiller(String(describing:Date().timeIntervalSince1970))
        
        if isLoggedIn {
            await _M.setIsLoginButtonPressed(true)
            let user:User = await Cognito.getUser(loggedInUser:loggedInUser)
            await _M.setUser(user)//updates on main thread asap
            await _M.setLoggedInUsername(user.userFirstNameLastI ?? _C.MPTY_STR)//updates on main thread asap
            //introduce delay here so user can see their name in progress view
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            await _M.setIsUserLoggedIn(true)//updates on main thread asap
            await _M.setMainViewChoice(.taskView)
            await LogsViewProxy.getLogs()//loading in background
            await _M.setIsLoginButtonPressed(false)
        }
    }
}
