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
    @State var fieldName:Field
    
    var lineLimit:ClosedRange<Int> = 1...1
    var fontFamily:String = "helvetica"
    var fontSize:CGFloat = 18
    var fontWeight:Font.Weight = Font.Weight.regular
    var bunPadding:CGFloat = 6
    var sidePadding:CGFloat = 20
    var actionOnAppear:()->Void = MarcaTextFieldBaseProxy.doNothing
    var actionOnFocusChange:(Field?,Field?)->Void = MarcaTextFieldBaseProxy.doNothing
    var submitAction:()->Void = MarcaTextFieldBaseProxy.doNothing
    
    var body: some View {
        VStack(alignment:.center, spacing:0){
            MarcaTextFieldBase(fieldName:fieldName, isSecure:isSecure, text:$text, pre:pre, submitAction:submitAction)
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
                .background(Color.marcaLightGray)
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius:5.0)
                        .stroke(Color.marcaLightGray, lineWidth:1)
                        .shadow(color: .gray, radius:1, x: 1, y:1)
                )
        }
        .padding([.top, .bottom], bunPadding)
        .padding([.leading, .trailing], sidePadding)
    }
    
    private func handleOnFocusChange(thisFieldMaybeFocused:Field?, fieldName:Field) {
        MarcaTextFieldBaseProxy.handleOnFocusChange(thisFieldMaybeFocused:thisFieldMaybeFocused, fieldName:fieldName)
        actionOnFocusChange(thisFieldMaybeFocused, fieldName)
    }
}

struct MarcaTextFieldBase: View {
    @State var fieldName:Field
    var isSecure:Bool = false
    
    @Binding var text:String
    @State var pre:String
    
    var prefixFontFamily:String = "verdana"
    var prefixFontSize:CGFloat = 14
    var submitAction:()->Void = MarcaTextFieldBaseProxy.doNothing
    
    var body: some View {
        ZStack{
            if (isSecure){
                if pre.count > 0{
                    SecureField(fieldName, text:$pre)
                        .padding(.textFieldPrefixEdgeInsets)
                        .font(.custom(prefixFontFamily, fixedSize:prefixFontSize))
                        .foregroundColor(Color.marcaDarkGray.opacity(0.6))
                        .fontWeight(.bold)
                        .disabled(true)
                }
                
                SecureField(fieldName, text:$text)
                    .padding(.textFieldEdgeInsets)
                
            }else{
                if pre.count > 0{
                    TextField(fieldName, text:$pre, axis:.vertical)
                        .padding(.textFieldPrefixEdgeInsets)
                        .font(.custom(prefixFontFamily, fixedSize:prefixFontSize))
                        .foregroundColor(Color.marcaDarkGray.opacity(0.6))
                        .fontWeight(.bold)
                        .disabled(true)
                }
                
                TextField(fieldName, text:$text, axis:.vertical)
                    .padding(.textFieldEdgeInsets)
                    .submitLabel(.send)
                    .submitScope(true)
                    .onSubmit { submitAction() }
            }
        }
    }
}

struct MarcaTextFieldBaseProxy:MarcaViewProxy{
    static var handleOnFocusChangeComplete:Bool = true
    
    static func handleOnViewAppear(_ model: _M?=nil, geometrySize: CGSize?=nil, items:any MarcaItem...) {
        print("MarcaTextField onAppear")
    }
    
    static func handleOnViewDisappear() {
        
    }
    
    public static func doNothing(){ print("???!!!") }
    public static func doNothing(thisFieldMaybeFocused:Field?=nil, fieldName:Field?=nil){}
    
    public static func handleOnFocusChange(thisFieldMaybeFocused:Field?, fieldName:Field){
        Task{
           while(!handleOnFocusChangeComplete){}
            
            if let model = _M.M(){
                handleOnFocusChangeComplete = false
            
                let fieldCurrentlyInFocus = model.fieldMaybeInFocus
                
                _D.dPrint("ContentViewProxy handleOnFocusChange: thisFieldMaybeFocused = \(thisFieldMaybeFocused ?? .emptyString)")
                _D.dPrint("ContentViewProxy handleOnFocusChange: fieldCurrentlyInFocus = \(fieldCurrentlyInFocus ?? .emptyString)")
                
                //yes. i agree. this is NUTS but it's exactly how one keeps track of what's in focus!
                if ((thisFieldMaybeFocused == nil && fieldCurrentlyInFocus == fieldName) || (thisFieldMaybeFocused != nil && fieldCurrentlyInFocus != fieldName)){
                    await _M.setFieldMaybeInFocus(thisFieldMaybeFocused)
                }
                
                await _M.setInEditingMode(model.fieldMaybeInFocus != nil)
                await _M.setAuthDidFail(false)
                
                _D.dPrint("ContentViewProxy handleOnFocusChange: inEditingMode = \(model.inEditingMode)")
                
                handleOnFocusChangeComplete = true
            }
        }
    }
}
