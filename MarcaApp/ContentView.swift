//
//  ContentView.swift
//  ContentView.swift
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dataModel:DataModel = DataModel.DM()
    
    @State private var logoutButtonText = "Logout"
    @State var showTaskView:Bool = false
    @State var showLoginView:Bool = false
    @State var showTaskViewButton:Bool = false
    @State var showLoginViewButton:Bool = false
    @State var loggedInUsername:String = "NO USERNAME"
    @State var welcomeLoggedInUser:Bool = false

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing:0) {
                VStack(alignment: .center, spacing:0) {
                    HStack(alignment: .bottom){
                        if (dataModel.loggedIn){
                            Text("😃")
                                .font(.custom("georgia", size: 24))
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 0))
                            
                            Spacer()
                            
                            Text(dataModel.loggedInUsername ?? "")
                                .font(.custom("georgia", size: 16))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
                            
                            Spacer()
                            
                            Button(action:handleLogoutButtonAction) {
                                Text(self.logoutButtonText)
                            }
                            .font(.custom("verdana", size: 11))
                            .foregroundColor(.black.opacity(0.6))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 20))
                            
                        }else{
                            Text("🤨")
                                .font(.custom("georgia", size: 24))
                                .padding(EdgeInsets(top: 11, leading: 20, bottom: 0, trailing: 15))
                            
                            Spacer()
                            
                            Text("Please Log In Below" )
                                .font(.custom("georgia", size: 17))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 6, trailing: 0))
                            
                            Spacer()
                            Spacer()
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 6, trailing: 0))
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .font(.custom("georgia", size: 15))
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black, .blue.opacity(0.5), .white, .white, .gray.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    )
                }
                .padding(EdgeInsets(top:0, leading:0, bottom:0, trailing:0))
                
                VStack(alignment: .center, spacing:0){
                    
                    if (dataModel.loggedIn){
                        TaskView()
                            .padding(0)
                            .border(Color.red, width:0)
                            .onAppear(perform: FlowController.handleOnTaskViewAppear)
                    }
                    
                    if (dataModel.loggedIn == false){
                        LogInView()
                            .padding(0)
                            .border(Color.red, width:0)
                            .onAppear(perform: { Task{ await FlowController.handleOnLoginViewAppear() } } )
                        
                        Spacer()
                    }
                }
            }
            
            /*
            .padding(EdgeInsets(top: 3, leading:4, bottom: 0, trailing: 4))
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [.black, .gray, .blue.opacity(0.7), .purple.opacity(0.6), .green.opacity(0.6), .orange.opacity(0.7), .red.opacity(0.7), .black.opacity(0.8) ]), startPoint: .top, endPoint: .bottom)
                        , lineWidth: 6)
            )
             */

        }
        .padding(0)
    }
    
    private func handleLogoutButtonAction(){
        Task{
            let logoutSuccess = await FlowController.handleLogoutButtonAction()
            self.logoutButtonText = logoutSuccess ? "Logout": "LOGOUT FAILED :: TRY AGAIN!!"
        }
    }
}
