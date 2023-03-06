//
//  ContentView.swift
//  ContentView.swift
//
//  Created by Enjoy on 12/8/22.
//
import Amplify
import SwiftUI

struct ContentView: View {
    @StateObject var model:_M = _M.M()

    var body: some View {
        VStack(alignment:.center, spacing:0){
            switch model.frameViewChoice {
                
                case .loginView:
                LoginView()
                    
                case .logoutChoiceView:
                LogoutChoiceView()
                    .transition(.scale)
                    
                case .taskView:
                TaskView()
                    .transition(.move(edge: .trailing))
                
                default:
                LoginView()
                
            }
        }
        .padding(0)
        .border(Color.red, width:_D.flt(1))
        .onAppear(perform:{ ContentViewProxy.handleOnViewAppear() })
        .animation(.default, value:model.frameViewChoice)
        .safeAreaInset(edge: .top, spacing:0) {
            MarcaHeader()
        }
        .safeAreaInset(edge:.bottom, spacing:0) {
            MarcaFooter()
        }
    }
}

class ContentViewProxy:MarcaViewProxy{
    static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {
        print("ContentView onAppear")
    }
    
    static func handleOnViewDisappear() {
        //TBD
    }
}
