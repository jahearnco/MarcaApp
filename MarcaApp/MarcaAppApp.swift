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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDele
    
    init(){
        do{
            //Amplify.Logging.logLevel = .error
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
            print("Amplify configured with auth plugin")
        }catch{
            print(error)
        }
        
        initCognito()
        initDataModel()
        initFlowController()
        
        /**
         * if user logged in handled in background thread
         * UI to respond/update asynchronously via dataModel @StateObject
         */
        Task{
            let loggedInUser:AuthUser? = await FlowController.getLoggedInUser()
            await FlowController.handleIfUserLoggedIn(loggedInUser:loggedInUser)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentViewParent()
                .onAppear(perform: {
                    Task{ await FlowController.handleOnContentViewParentAppear() }
                    UIApplication.shared.addTapGestureRecognizer()
                } )
        }
    }
    
    private func initFlowController() {
        FlowController.setAppDelegate(appDele:appDele)
    }
  
    /*
     * static Singleton instance: instantiate once/store once
     * attempts to try this again won't be pretty, but you can certainly try;-)
     * strongly suggest that the instance is acquired via DataModel.getSingletonInstance()
     * after setting it below
     */
    private func initDataModel() {
        let dataModel = MarcaClassFactory.getInstance(className:"DataModel", kType: DataModel.self, instanceLabel:"dmA") as? DataModel
        print("dataModel initialized : \(dataModel!.getInstanceLabel()) ")
    }
    
    /*
     * Cognito need not be a class for now. this is for future impls
     * static Singleton instance: instantiate once/store once
     * attempts to try this again won't be pretty, but you can certainly try;-)
     * strongly suggest that the instance is acquired via DataModel.getSingletonInstance()
     * after setting it below
     */
    private func initCognito() {
        let cognito = MarcaClassFactory.getInstance(className:"Cognito", kType: Cognito.self, instanceLabel:"cogA") as? Cognito
        print("cognito initialized : \(cognito!.getInstanceLabel()) ")
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = firstScene.windows.first else { return }
        
        let tapGesture = UITapGestureRecognizer(target: firstWindow, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        firstWindow.addGestureRecognizer(tapGesture)
    }
}

 extension UIApplication: UIGestureRecognizerDelegate {
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true // set to `false` if you don't want to detect tap during other gestures
     }
 }
