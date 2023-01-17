//
//  LoginView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct LogInView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var loginButtonPressed = false
    @State private var u: String = ""
    @State private var p: String = ""
    
    let name: String = "noname"
    
    var body: some View {

        GeometryReader { gp1 in
            ZStack(alignment:.center){
                VStack {
                    Spacer()
                    VStack {
                        Section(header: Text("").font(.headline)) {TextField("Enter your name", text: $u)}
                        .padding(6)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if (u != ""){Text("Hello, \(u)!")}
                        
                        Section(header: Text("").font(.headline)) {TextField("Enter your pass", text: $p)}
                        .padding(6)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if (p != ""){
                            Text("Hello, \(p)!")
                        }
                    }
                    .border(Color.white, width:6)
                    .font(.custom("helvetica", size: 18))
                    .padding(4)
                    
                    Spacer()
                    
                    VStack {
                        Button(action: { loginButtonAction(autoLogin:false) }) {Text("Login")}
                        .font(.custom("verdana", size: 20))
                        .foregroundColor(loginButtonPressed ? .purple : .white)
                        .padding(EdgeInsets(top:5, leading:40, bottom:9, trailing:40))
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(loginButtonPressed ? Color.white : Color.purple)
                        )
                        Spacer()
                        Button(action: { loginButtonAction(autoLogin:true) }) {Text("AutoLogin")}
                        .font(.custom("verdana", size: 20))
                        .foregroundColor(loginButtonPressed ? .purple : .white)
                        .padding(EdgeInsets(top:5, leading:40, bottom:9, trailing:40))
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(loginButtonPressed ? Color.white : Color.purple)
                        )
                    }
                    Spacer()
                }
                .border(Color.white, width:0)
                .padding(0)
                
                ProgressView()
                    .opacity(loginButtonPressed ? 1 : 0)
            }
        }
        .border(Color.white, width:0)
        .padding(0)
    }
    
    func loginButtonAction(autoLogin:Bool){
        /**
         * Login handled in background thread
         * UI to respond/update asynchronously via dataModel @StateObject
         */
        Task{
            self.loginButtonPressed = true
            let _ = await FlowController.handleLoginButtonAction(autoLogin:autoLogin)
            self.loginButtonPressed = false
        }
    }
}

struct LoginButtonStyle: ButtonStyle  {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(EdgeInsets(top:8, leading:50, bottom:12, trailing:50))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.red, lineWidth: 3)
        ).padding()
    }
}
