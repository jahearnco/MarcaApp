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
            switch model.mainViewChoice {
                
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
        .onAppear(perform:ContentViewProxy.handleOnContentViewAppear)
        .animation(.default, value:model.mainViewChoice)
        .safeAreaInset(edge: .top, spacing:0) {
            MarcaHeader()
        }
        .safeAreaInset(edge:.bottom, spacing:0) {
            MarcaFooter()
        }
    }
}

class ContentViewProxy{
    static var model:_M = _M.M()
    static var handleOnFocusChangeComplete:Bool = true

    public static func handleOnFocusChange(thisFieldMaybeFocused:Field?, fieldName:Field){
        Task{
            while(!handleOnFocusChangeComplete){}

            handleOnFocusChangeComplete = false
            
            let fieldCurrentlyInFocus = model.fieldMaybeInFocus
            
            print("ContentViewProxy handleOnFocusChange: thisFieldMaybeFocused = \(thisFieldMaybeFocused ?? _C.MPTY_STR)")
            print("ContentViewProxy handleOnFocusChange: fieldCurrentlyInFocus = \(fieldCurrentlyInFocus ?? _C.MPTY_STR)")
            
            //yes. i agree. this is NUTS but it's exactly how one keeps track of what's in focus!
            if ((thisFieldMaybeFocused == nil && fieldCurrentlyInFocus == fieldName) || (thisFieldMaybeFocused != nil && fieldCurrentlyInFocus != fieldName)){
                await _M.setFieldMaybeInFocus(thisFieldMaybeFocused)
            }
            
            await _M.setInEditingMode(model.fieldMaybeInFocus != nil)
            
            await _M.setAuthDidFail(false)
            
            print("ContentViewProxy handleOnFocusChange: inEditingMode = \(model.inEditingMode)")
            
            handleOnFocusChangeComplete = true
        }
    }
    
    public static func handleOnContentViewAppear(){
        Task{
            await _M.updateTextGroupEmps([])
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
        }
    }
}
