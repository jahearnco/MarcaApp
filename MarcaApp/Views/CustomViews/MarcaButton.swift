//
//  MarcaButton.swift
//  MarcaApp
//
//  Created by Enjoy on 12/23/22.
//
import Amplify
import SwiftUI

struct MarcaButton: View {
    @StateObject var model:_M = _M.M()

    var action:()->Void
    var fieldName:String = _C.MPTY_STR
    var textBody:String
    var type:Int
    var disabled:Bool = false
    
    var body: some View {
        Button(action:action){
            Text(textBody)
                .font(.headline)
                .padding(EdgeInsets(top:6, leading:40, bottom:6, trailing:40))
        }
        .background(RoundedRectangle(cornerRadius:8, style:.continuous).fill(getFillColor()))
        .foregroundColor(.white)
        .padding([.top,.bottom],6)
        .border(Color.black, width:_D.flt(1))
        .disabled(disabled)
    }
                    
    private func getFillColor()->Color{
        return disabled ? _C.marcaLightGray : type == _C.BUTTON_SUBMIT ? _C.deepBlueViolet : _C.marcaRed
    }
}
