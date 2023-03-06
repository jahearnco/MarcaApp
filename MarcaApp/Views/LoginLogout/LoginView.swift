//
//  LoginView
//  LoginView.swift
//
//  Created by Enjoy on 12/8/22.
//

import Amplify
import SwiftUI

struct LoginView : View {
    @StateObject var model:_M = _M.M()
    
    @FocusState private var maybeFocusedField:Field?
    
    @State var username:String = "XXXX"
    @State var password:String = .emptyString
    @State var keychainPassword:String?
    @State var hideWelcomeText:Bool = false
    @State var welcomeText:String = "Please Login"
    
    let usernameFieldName = "Input Username"
    let passwordFieldName = "Input Password"
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack(alignment:.center, spacing:0){
                    WelcomeText(hideText:$hideWelcomeText, text:$welcomeText)
                    MarcaTextField(text:$username, fieldName:usernameFieldName, fontSize:22, fontWeight:.semibold, actionOnAppear:setStoredCreds, actionOnFocusChange:performWhenUnFocused)
                    MarcaTextField(isSecure:true, text:$password, fieldName:passwordFieldName, fontSize:22, fontWeight:.semibold, actionOnFocusChange:performWhenFocused)
                    MarcaButton(action:handleLoginButtonAction, fieldName:"LoginButton", textBody:"LOGIN", type:.buttonSubmit, disabled:disableButton())
                    Spacer()
                }
                .padding(0)
                .border(Color.black, width:_D.flt(1))
            }
            .padding(0)
            .border(Color.green, width:_D.flt(1))
            .focused($maybeFocusedField, equals:usernameFieldName)
            .focused($maybeFocusedField, equals:passwordFieldName)
            .onChange(of:maybeFocusedField, perform:{ mff in
                hideWelcomeText = (mff != nil)
            })

            ProgressView(getProgressViewLabel(model.isUserLoggedIn, model.loggedInUsername))
                .opacity(model.isLoginButtonPressed || model.loggedInUsername != "" ? 1 : 0)
                .foregroundColor(.marcaGray)
                .font(.system(size: 24, weight:.semibold, design:.default))
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .border(Color.yellow, width:_D.flt(1))
        .onAppear(perform:{ LoginViewProxy.handleOnViewAppear() })
        .onChange(of:model.isLoginButtonPressed, perform:{ ilbp in
            hideWelcomeText = ilbp
        })
        .onTapGesture { _M.setTapOccurred(true) }
    }
    
    private func getProgressViewLabel(_ loggedIn:Bool, _ name:String)->String{
        return name != "" && !loggedIn ? "Welcome \(name) ..." : ""
    }
    
    private func setStoredCreds(){
        let (pw, kpw) = LoginViewProxy.setStoredCreds(username:username)
        password = pw
        keychainPassword = kpw
    }
    
    private func performWhenFocused(thisFieldMaybeFocused:Field?=nil, fieldName:Field?=nil){
        if (thisFieldMaybeFocused == fieldName){
            setStoredCreds()
        }
    }
    
    private func performWhenUnFocused(thisFieldMaybeFocused:Field?=nil, fieldName:Field?=nil){
        if (thisFieldMaybeFocused == nil){
            setStoredCreds()
        }
    }
    
    private func disableButton()->Bool{
        return username.count == 0 || password.count == 0
    }
    
    private func handleLoginButtonAction(){
        LoginViewProxy.handleLoginButtonAction(username:username, password:password, keychainPassword:keychainPassword)
    }
}

struct WelcomeText : View {
    @StateObject var model:_M = _M.M()
    @Binding var hideText:Bool
    @Binding var text:String

    var body: some View {
        if !hideText {
            Text(text)
                .font(.system(size: 22, weight:.bold, design:.default))
                .padding(EdgeInsets(top:20, leading:0, bottom:14, trailing:0))
                .border(Color.red, width:_D.flt(1))
        }
    }
}

/*
struct PurgeButtonContent : View {

    var body: some View {
        let backgroundColor = Color.black
        Text("PURGE KEYCHAIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding(_C.BUTTON_EDGE_INSETS)
            .frame(width: 220)
            .background(backgroundColor)
            .cornerRadius(15.0)
    }
 
    private func handlePurgeButtonAction(){
        KeychainProxy.deleteKeychainItems()
    }
}
*/

struct LoginViewProxy:MarcaViewProxy{
    static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {
        
    }
    
    static func handleOnViewDisappear() {
        
    }
    
    
    public static func setStoredCreds(username:String)->(String,String?){
        //storedUsername hardcoded for now. will grab is programatically later
        var password:String = .emptyString
        var keychainPassword:String?
        
        if (username.count > 0){
            keychainPassword = LoginViewProxy.getSavedPassword(creds:Credentials(username:username))
            password = keychainPassword ?? .emptyString
        }
        print("setStoredCreds username : \(username)")
        print("setStoredCreds password : \(password)")
        
        return (password,keychainPassword)
    }
    
    public static func getSavedPassword(creds:Credentials)->String?{
        return KeychainProxy.loadKeychainPassword(creds:creds)
    }
    
    public static func handleLoginButtonAction(username:String?, password:String?, keychainPassword:String?){
        Task{
            await _M.setIsLoginButtonPressed(true)
            let loginSuccess = await doLogin(username:username, password:password, keychainPassword:keychainPassword)
            let loggedInUser:AuthUser? = loginSuccess ? await CognitoProxy.getLoggedInUser() : nil
            
            await AppInitProxy.handleIfUserLoggedIn(loggedInUser:loggedInUser) //explicitly state nil loggedInUser as opposed to loggedInUser with missing attribs
            
            if loginSuccess {
                await _M.setTaskViewChoice(.logsView)
            }
            
            await _M.setAuthDidFail(!loginSuccess)
            await _M.setIsLoginButtonPressed(false)
        }
    }
    
    public static func doLogin(username:String?, password:String?, keychainPassword:String?) async -> Bool{
        //to get here must have password.count > 0 or else button won't be enabled
        var saveType:Int
        if password != keychainPassword{
            saveType = (keychainPassword?.count ?? 0) > 0 ? KeychainProxy.KEYCHAIN_ITEM_PERSIST_UPDATE : KeychainProxy.KEYCHAIN_ITEM_PERSIST_NEW
        }else{
            saveType = KeychainProxy.KEYCHAIN_ITEM_NO_PERSIST
        }
        
        print("LoginView handleLoginButtonAction keychainPassword : \(keychainPassword ?? .emptyString)")
        print("LoginView handleLoginButtonAction password : \(password ?? .emptyString)")
        print("LoginView handleLoginButtonAction saveType : \(saveType)")
        
        return await Cognito.doLogin(username:username?.lowercased(), password:password, saveType:saveType)
    }
}
