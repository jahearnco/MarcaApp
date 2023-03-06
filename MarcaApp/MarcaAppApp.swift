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
        let mA = MarcaClassFactory.getInstance(className:"_M", kType: _M.self, instanceLabel:"modelA") as? _M
        print("model initialized : \(mA!.getInstanceLabel()) ")
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

struct AppInitProxy{
    public static func handleIfUserLoggedIn(loggedInUser:AuthUser?)async{
        print("AppInitProxy handleIfUserLoggedIn ...")
        let isLoggedIn = loggedInUser != nil
        
        /** REMIND: the order of the next two lines is critical. and a problem. FIX IT*/
        await _M.setTaskViewChoice(.logsView)
        await _M.setFrameViewChoice(.loginView)
        
        if isLoggedIn {
            let user:User = await Cognito.getUser(loggedInUser:loggedInUser)
            await _M.setUser(user)//updates on main thread asap
            await _M.setLoggedInUsername(user.userFirstNameLastI ?? .emptyString)//updates on main thread asap
            
            //introduce delay here so user can see their name in progress view
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            
            await _M.setIsUserLoggedIn(true)//updates on main thread asap
            await _M.setFrameViewChoice(.taskView)
        }
        
        await _M.setCacheKiller(String(describing:Date().timeIntervalSince1970))
    }
}
