//
//  LogoutChoiceView
//  LogoutChoiceView.swift
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct LogoutChoiceView : View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()

    var body: some View {
        ZStack {
            VStack(spacing:0){
                LogoutChoiceText()
                MarcaButton(action:LogoutChoiceViewProxy.handleLogoutButtonAction, textBody:"LOGOUT", type:_C.BUTTON_SUBMIT)
                MarcaButton(action:LogoutChoiceViewProxy.handleCancelLogoutButtonAction, textBody:"CANCEL", type:_C.BUTTON_CANCEL)
                Spacer()
            }
        
            ProgressView()
                .opacity(model.isLogoutChoiceButtonPressed ? 1 : 0)
        }
        .padding(0)
        .border(Color.red, width:_D.flt(1))
        .onChange(of:model.mainViewChoice, perform:{ mvc in
            if mvc != .logoutChoiceView { dismiss() }
        })
    }

}

struct LogoutChoiceText : View {
    var body: some View {
        Text("Logout From MARCA?")
            .font(.system(size: 22, weight:.bold, design:.default))
            .padding(EdgeInsets(top:20, leading:0, bottom:14, trailing:0))
            .border(Color.red, width:_D.flt(0))
    }
}

struct LogoutChoiceViewProxy{
    
    public static func handleLogoutButtonAction(){
        Task{
            await _M.setIsLogoutChoiceButtonPressed(true)
            let logoutSuccess:Bool = await Cognito.authSignOut()

            if logoutSuccess {
                await _M.setLoggedInUsername(_C.MPTY_STR)
                await _M.setIsUserLoggedIn(false)
                await _M.setMainViewChoice(.loginView)
            }else{
                await _M.setMainViewChoice(.taskView)
            }
            await _M.setIsLogoutChoiceButtonPressed(false)
        }
    }
    
    public static func handleCancelLogoutButtonAction()  {
        Task{
            await _M.setMainViewChoice(.taskView)
        }
    }
}
