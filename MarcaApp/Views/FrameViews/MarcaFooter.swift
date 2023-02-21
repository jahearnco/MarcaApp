//
//  MarcaFooter.swift
//  MarcaApp
//
//  Created by Enjoy on 2/2/23.
//

import SwiftUI


struct MarcaFooter: View {
    @StateObject var model:_M = _M.M()
    @State var height:CGFloat = _C.FOOTER_HEIGHT
    
    var body: some View {
        if (!model.inEditingMode){
            HStack(alignment:.top, spacing: 0){
                if (model.isUserLoggedIn){
                    
                    Button(action:showCreateTextButtonAction) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width:28.0, height:28.0)
                    }
                    .padding(0)
                    .padding(EdgeInsets(top:0, leading:40, bottom:12, trailing:25))
                    
                    Spacer()
                    
                    Button(action:showLogsViewButtonAction) {
                        Image(systemName: "tray.full")
                            .resizable()
                            .frame(width:28.0, height:28.0)
                    }
                    .padding(0)
                    .padding(EdgeInsets(top:0, leading:25, bottom:12, trailing:25))
                    
                    Spacer()
                    
                    Button(action:showEditProfilesButtonAction) {
                        Image(systemName: "person.text.rectangle")
                            .resizable()
                            .frame(width:28.0, height:28.0)
                    }
                    .padding(0)
                    .padding(EdgeInsets(top:0, leading:25, bottom:12, trailing:25))
                    
                    Spacer()
                    
                    Button(action:showLogoutChoiceButtonAction) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width:30.0, height:26.0)
                    }
                    .padding(0)
                    .padding(EdgeInsets(top:0, leading:25, bottom:12, trailing:40))
 
                }else{
                    Spacer()
                    
                    Text(getCaption(authDidFail:model.authDidFail))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(_C.marcaRed)
                        .padding(EdgeInsets(top:0,leading:0,bottom:12,trailing:0))
                    
                    Spacer()
                }
            }
            .padding(0)
            .border(Color.blue, width:_D.flt(1))
            .frame(height:model.footerHeight)
            .foregroundColor(Color.black)
            .onAppear(perform: { _M.setFooterHeight(height) } )
            .onChange(of:height, perform: { h in _M.setFooterHeight(h) } )
            .background(
                LinearGradient(gradient: Gradient(colors:[
                    .gray.opacity(0.1),
                    .white,
                    .white,
                    .white,
                    .white,
                    .white,
                    _C.deepBlueViolet,
                    .black
                ]), startPoint: .top, endPoint: .bottom)
            )
            .onTapGesture { _M.setTapOccurred(true) }
        }
    }
    
    func getCaption(authDidFail:Bool)->String{
        var retMssg:String = _C.MPTY_STR
        if (authDidFail) {
            retMssg = "Login Info is not correct. Try again."
        }
        return retMssg
    }
    
    private func showEditProfilesButtonAction(){
        _M.setTaskViewChoice(.editProfileView)
    }
    
    private func showLogsViewButtonAction(){
        print("handleGetLogsButtonAction invoked ...")
        _M.setProfileGroupCats([])
        _M.updateProfileGroupEmployees([])
        _M.updateProfileStaffNotes([])
        _M.setTaskViewChoice(.logsView)
        Task{
            await LogsViewProxy.getLogs()
        }

    }
    
    private func showCreateTextButtonAction(){
        _M.setTaskViewChoice(.textCreateView)
    }
    
    func showLogoutChoiceButtonAction(){
        _M.setMainViewChoice(.logoutChoiceView)
    }
}


