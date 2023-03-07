//
//  _M.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/8/23.
//
import Amplify
import SwiftUI

/**
 view state and data model
 @Published vars and static public functions
 static class behavior: singleton instance and static public methods
 required init disallows attempt to create multiple instances during compilation
 */
final class _M:MarcaClass,ObservableSingleton {
    /**begin:Requirements to adhere to Singleton Protocol*/
    private static var _inst:Singleton?
    static func getStaticInstance() -> Singleton? { return _inst as? Self }
    static func setStaticInstance(si: Singleton!) { _inst = si as! Self }
    /**end:Requirements to adhere to Singleton Protocol*/

    public static func M()->_M!{
        if let _ = _inst{
            return _inst as? _M
        }else{
            return nil
        }
    }

    @Published var cacheKiller:String = .emptyString
    @MainActor
    public static func setCacheKiller(_ cacheKiller:String){
        M().cacheKiller = cacheKiller
    }
    
    @Published var isPortraitOrientation:Bool = true
    @MainActor
    public static func setIsPortraitOrientation(_ isPortraitOrientation:Bool){
        M().isPortraitOrientation = isPortraitOrientation
    }
    
    @Published var isLoginButtonPressed:Bool = false
    @MainActor
    public static func setIsLoginButtonPressed(_ isLoginButtonPressed:Bool){
        M().isLoginButtonPressed = isLoginButtonPressed
    }

    @Published var headerHeight:CGFloat = .headerHeightPortrait
    @MainActor
    public static func setHeaderHeight(_ headerHeight:CGFloat){
        M().headerHeight = headerHeight
    }
    
    @Published var footerHeight:CGFloat = 0
    @MainActor
    public static func setFooterHeight(_ footerHeight:CGFloat){
        M().footerHeight = footerHeight
    }
    
    @Published var menuDoesAppear:Bool = false
    @MainActor
    public static func setMenuDoesAppear(_ menuDoesAppear:Bool){
        M().menuDoesAppear = menuDoesAppear
    }
    
    @Published var tapOccurred:Bool = false
    @MainActor
    public static func setTapOccurred(_ tapOccurred:Bool){
        M().tapOccurred = tapOccurred
    }
    
    @Published var fieldMaybeInFocus:Field?
    @MainActor
    public static func setFieldMaybeInFocus(_ fieldMaybeInFocus:Field?){
        M().fieldMaybeInFocus = fieldMaybeInFocus
    }
    
    @Published var inEditingMode:Bool = false
    @MainActor
    public static func setInEditingMode(_ inEditingMode:Bool){
        M().inEditingMode = inEditingMode
    }
    
    @Published var authDidFail:Bool = false
    @MainActor
    public static func setAuthDidFail(_ authDidFail:Bool){
        M().authDidFail = authDidFail
    }
    
    @Published var frameViewChoice:MarcaViewChoice = .noView
    @MainActor
    public static func setFrameViewChoice(_ frameViewChoice:MarcaViewChoice){
        M().frameViewChoice = frameViewChoice
        setCurrentView(frameViewChoice)
    }
    
    @Published var taskViewChoice:MarcaViewChoice = .noView
    @MainActor
    public static func setTaskViewChoice(_ taskViewChoice:MarcaViewChoice){
        M().taskViewChoice = taskViewChoice
        setCurrentView(taskViewChoice)
    }
 
    @Published var currentView:MarcaViewChoice = .noView
    @MainActor
    public static func setCurrentView(_ currentView:MarcaViewChoice){
        M().currentView = currentView
    }
    
    @Published var isLogoutChoiceButtonPressed:Bool = false
    @MainActor
    public static func setIsLogoutChoiceButtonPressed(_ isLogoutChoiceButtonPressed:Bool){
        M().isLogoutChoiceButtonPressed = isLogoutChoiceButtonPressed
    }
    
    @Published var appFullScreenAspectRatio:CGFloat = 1
    @MainActor
    public static func setAppFullScreenAspectRatio(_ aspectRatio:CGFloat){
        M().appFullScreenAspectRatio = aspectRatio
    }
    
    @Published var appFullWidth:CGFloat = 0
    @MainActor
    public static func setAppFullWidth(_ width:CGFloat){
        M().appFullWidth = width
    }

    @Published var appFullHeight:CGFloat = 0
    @MainActor
    public static func setAppFullHeight(_ height:CGFloat){
        M().appFullHeight = height
    }
    
    @Published var isLoggingOut:Bool = false
    @MainActor
    public static func setIsLoggingOut(_ loggingOut:Bool){
        M().isLoggingOut = loggingOut
    }
    
    @Published var isUserLoggedIn:Bool = false
    @MainActor
    public static func setIsUserLoggedIn(_ isUserLoggedIn:Bool){
        M().isUserLoggedIn = isUserLoggedIn
    }

    @Published var loggedInUsername:String = .emptyString
    @MainActor
    public static func setLoggedInUsername(_ loggedInUsername:String){
        M().loggedInUsername = loggedInUsername
    }
    
    @Published var user:User?
    @MainActor
    public static func setUser(_ user:User?){
        M().user = user
    }
    
    @Published var overlayIsShowing:Bool = false
    public static func setOverlayIsShowing(_ overlayIsShowing:Bool){
        M().overlayIsShowing = overlayIsShowing
    }

    @Published var communityLogs:[MarcaLogItem] = []
    @MainActor
    public static func updateCommunityLogs(_ communityLogs:[MarcaLogItem]){
        M().communityLogs = communityLogs
    }
}
