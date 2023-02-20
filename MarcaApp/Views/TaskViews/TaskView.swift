//
//  TaskView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct TaskView: View {
    @StateObject var model:_M = _M.M()
    @State var inEditingMode:Bool = false
    
    var body: some View {
        ZStack{
            VStack(alignment:.center, spacing:0) {
                switch model.taskViewChoice {
                    
                    case .logsView:
                    CommunityLogsView()
                        .transition(.move(edge: .bottom))
                        
                    case .textCreateView:
                    TextCreateView()
                        .transition(.move(edge: .top))
                        
                    case .editProfileView:
                    EditProfileView()
                        .transition(.move(edge: .leading))
                    
                    default:
                    EditProfileView()
                        .transition(.scale)
                }
            }
            .border(Color.green, width:_D.flt(1))
            .padding(0)
            .foregroundColor(.black)
            .font(.custom("verdana", size: 14))
            .fontWeight(.bold)
            .animation(.default, value:model.taskViewChoice)
            
            ProgressView()
                .opacity(model.isLoggingOut || model.loggedInUsername == _C.MPTY_STR ? 1 : 0)
        }
        .padding(0)
        .border(Color.green, width:_D.flt(1))
        .onAppear(perform: TaskViewProxy.handleOnTaskViewAppear)
    }
}

struct TaskViewProxy{
    public static func handleOnTaskViewAppear(){
        Task{
            await _M.updateTextGroupEmps([])
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
        }
    }
}
