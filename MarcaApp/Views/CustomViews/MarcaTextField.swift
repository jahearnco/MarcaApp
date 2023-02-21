//
//  MarcaTextField.swift
//  MarcaApp
//
//  Created by Enjoy on 12/23/22.
//
import Amplify
import SwiftUI

struct MarcaTextField: View{
    @StateObject var model:_M = _M.M()
    @FocusState private var maybeFocusedField:Field?
    
    var isSecure:Bool = false
    
    @Binding var text:String
    
    @State var pre:String = ""
    @State var fgColor:Color = Color.black
    
    var fieldName:String
    var lineLimit:ClosedRange<Int> = 1...1
    var fontFamily:String = "helvetica"
    var fontSize:CGFloat = 18
    var fontWeight:Font.Weight = Font.Weight.regular
    var bunPadding:CGFloat = 6
    var sidePadding:CGFloat = 20
    var actionOnAppear:()->Void = MarcaTextFieldBaseProxy.doNothing
    var actionOnFocusChange:(Field?,Field?)->Void = MarcaTextFieldBaseProxy.doNothing
    
    var body: some View {
        VStack(alignment:.center, spacing:0){
            MarcaTextFieldBase(fieldName:fieldName, isSecure:isSecure, text:$text, pre:pre)
                .padding(0)
                .lineLimit(lineLimit)
                .font(.custom(fontFamily, fixedSize:fontSize))
                .fontWeight(fontWeight)
                .foregroundColor(fgColor)
                .multilineTextAlignment(.leading)
                .onAppear(perform:actionOnAppear)
                .focused($maybeFocusedField, equals:fieldName)
                .onChange(of:maybeFocusedField, perform:{ mff in
                    handleOnFocusChange(thisFieldMaybeFocused:mff, fieldName:fieldName)
                } )
                .background(_C.marcaLightGray)
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius:5.0)
                        .stroke(_C.marcaLightGray, lineWidth:1)
                        .shadow(color: .gray, radius:1, x: 1, y:1)
                )
        }
        .padding([.top, .bottom], bunPadding)
        .padding([.leading, .trailing], sidePadding)
    }
    
    private func handleOnFocusChange(thisFieldMaybeFocused:Field?, fieldName:Field) {
        ContentViewProxy.handleOnFocusChange(thisFieldMaybeFocused:thisFieldMaybeFocused, fieldName:fieldName)
        actionOnFocusChange(thisFieldMaybeFocused, fieldName)
    }
}

struct MarcaTextFieldBase: View {
    var fieldName:String
    var isSecure:Bool = false
    
    @Binding var text:String
    @State var pre:String
    
    var prefixFontFamily:String = "verdana"
    var prefixFontSize:CGFloat = 14
    
    var body: some View {
        ZStack{
            if (isSecure){
                if pre.count > 0{
                    SecureField(fieldName, text:$pre)
                        .padding(_C.TEXT_FIELD_PREFIX_EDGE_INSETS)
                        .font(.custom(prefixFontFamily, fixedSize:prefixFontSize))
                        .foregroundColor(_C.marcaDarkGray.opacity(0.6))
                        .fontWeight(.bold)
                        .disabled(true)
                }
                
                SecureField(fieldName, text:$text)
                    .padding(_C.TEXT_FIELD_EDGE_INSETS)
                
            }else{
                if pre.count > 0{
                    TextField(fieldName, text:$pre, axis:.vertical)
                        .padding(_C.TEXT_FIELD_PREFIX_EDGE_INSETS)
                        .font(.custom(prefixFontFamily, fixedSize:prefixFontSize))
                        .foregroundColor(_C.marcaDarkGray.opacity(0.6))
                        .fontWeight(.bold)
                        .disabled(true)
                }
                
                TextField(fieldName, text:$text, axis:.vertical)
                    .padding(_C.TEXT_FIELD_EDGE_INSETS)
            }
        }
    }
}

struct MarcaTextFieldBaseProxy{
    public static func doNothing(){}
    public static func doNothing(thisFieldMaybeFocused:Field?=nil, fieldName:Field?=nil){}
}
