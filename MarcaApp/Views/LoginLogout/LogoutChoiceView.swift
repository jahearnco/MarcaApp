//
//  LogoutChoiceView
//  LogoutChoiceView.swift
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct LogoutChoiceView : View {
    @StateObject var model:_M = _M.M()

    var body: some View {
        ZStack {
            VStack(spacing:0){
                LogoutChoiceText()
                MarcaButton(action:LogoutChoiceViewProxy.handleLogoutButtonAction, textBody:"LOGOUT", type:.buttonSubmit)
                MarcaButton(action:{ LogoutChoiceViewProxy.handleCancelLogoutButtonAction(model.taskViewChoice) }, textBody:"CANCEL", type:.buttonCancel)
                Spacer()
            }
        
            ProgressView()
                .opacity(model.isLogoutChoiceButtonPressed ? 1 : 0)
        }
        .padding(0)
        .border(Color.red, width:_D.flt(1))
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

struct LogoutChoiceViewProxy:MarcaViewProxy{
    static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {
        //TBD
    }
    
    static func handleOnViewDisappear() {
        //TBD
    }
    
    public static func handleLogoutButtonAction(){
        Task{
            await _M.setIsLogoutChoiceButtonPressed(true)
            let logoutSuccess:Bool = await Cognito.authSignOut()

            if logoutSuccess {
                await _M.setLoggedInUsername(.emptyString)
                await _M.setIsUserLoggedIn(false)
                await _M.setFrameViewChoice(.loginView)
            }else{
                await _M.setFrameViewChoice(.taskView)
            }
            await _M.setIsLogoutChoiceButtonPressed(false)
        }
    }
    
    public static func handleCancelLogoutButtonAction(_ currentTaskView:MarcaViewChoice)  {
        Task{
            await _M.setFrameViewChoice(.taskView)
            await _M.setTaskViewChoice(currentTaskView)
        }
    }
}
