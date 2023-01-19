//
//  TaskView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataModel:DataModel = DataModel.DM()

    @State var text = "Hello World"
    
    @State private var logoutButtonText = "Logout"
    @State private var u: String = ""
    @State private var p: String = ""
    
    let name: String = "noname"

    var body: some View {
        GeometryReader {gr0 in
            VStack(alignment: .center) {
                HStack(alignment: .bottom) {
                    if (dataModel.showLogListTask){
                        LogsView()
                            .onAppear(perform: FlowController.handleOnLogsViewAppear)
                    }
                    
                    if (dataModel.showTextCreateTask){
                        TextCreateView()
                            .onAppear(perform: { Task{ await FlowController.handleOnTextCreateViewAppear() } } )
                    }
                }
                .padding(EdgeInsets(top:10, leading:0, bottom:0, trailing:0))
                .border(Color.green, width:0)
                .frame(height: gr0.size.height-48)
                
                Spacer()
                
                HStack(alignment: .top) {
                    
                    
                    Button(action: { getLogsButtonAction() }) {
                        Text("Get Logs")
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 4, trailing: 0))
                    
                    Spacer()
                    
                    Button("Create Text") {
                        Task{ await FlowController.showTextCreateTask() }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 20))
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 14, trailing: 0))
                .foregroundColor(.white)
                .font(.custom("verdana", size: 14))
                .fontWeight(.bold)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.1), .blue.opacity(0.9), .gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                )
                .border(Color.green, width:0)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }
    }
    
    private func getLogsButtonAction(){
        Task{ await FlowController.handleGetLogsButtonAction() }
    }
}
