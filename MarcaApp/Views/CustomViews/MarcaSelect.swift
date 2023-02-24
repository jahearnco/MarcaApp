//
//  MarcaSelect.swift
//  MarcaApp
//
//  Created by Enjoy on 2/14/23.
//

import Amplify
import SwiftUI

struct MarcaSelect: View{
    @StateObject var model:_M = _M.M()
    
    @Binding var selection:String
    
    @Binding var marcaSelectType:MarcaSelectType
    @State var width:CGFloat
    @State var height:CGFloat
    
    @State var key:String
    @State var tapCount:Int = 0
    @State var choices:[String] = [_C.MPTY_STR]
    
    var imageWidth:CGFloat = 13
    var imageHeight:CGFloat = 13
    var selectImage:Image
    var strokeColor:Color = _C.marcaLightGray
    var bgColor:Color = _C.marcaLightGray
    var performImmediateAction:Bool = false
    var action:()->Void = MarcaTextFieldBaseProxy.doNothing
    
    @Binding var title:String
    @Binding var refreshChoiceCount:Int
    
    var body: some View{
        VStack(alignment: .center, spacing:0){
            Menu {
                Picker("Status", selection:$selection) {
                    ForEach(choices, id: \.self){ choice in
                        Button() {
                            // do something
                        } label: {
                            HStack(alignment:.center, spacing:0){
                                Text(choice)
                                    .onAppear(perform:handleTextViewAppeared)
                                    .onDisappear(perform:handleTextViewDisappeared)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .resizable()
                                    .frame(width:28.0, height:28.0)
                                    .padding(EdgeInsets(top:0, leading:0, bottom:0, trailing:20))
                            }
                        }
                    }
                }
                .onAppear(perform:handlePickerOnAppear)
                .onDisappear(perform:handlePickerOnDisappear)
                
            } label: {
                HStack(alignment:.center, spacing:0){
                    
                    Text(title)
                        .foregroundColor(_C.marcaGray)
                        .font(.custom("helvetica", size:13))
                        .padding(0)
                    Spacer()
                    
                    selectImage
                        .resizable()
                        .frame(width:imageWidth, height:imageHeight)
                        .padding(0)
                }
                .frame(width:width, height:height)
                .padding(_C.TEXT_FIELD_EDGE_INSETS)
                .border(Color.red,width:_D.flt(1))
                .background(bgColor)
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius:5.0)
                        .stroke(strokeColor, lineWidth:1)
                        .shadow(color: .gray, radius:1, x: 1, y:1)
                )
                
            }
            .padding([.top, .bottom], 4)
            .padding([.leading, .trailing], 2)
            .border(Color.green,width:_D.flt(1))
        }
        .padding(0)
        .onChange(of:model.tapOccurred, perform: { t in
            handleTapOccurredChange(wasTapped:t, outsideTap:true)
        })
        .onChange(of:refreshChoiceCount, perform:{rc in handleRefreshChoices() })
        .onChange(of:marcaSelectType, perform: {t in handleTypeChange() })
        .onChange(of:model.taskViewChoice, perform: {tvc in handleTypeChange() })
        .onChange(of:model.mainViewChoice, perform: {mvc in handleTypeChange() })
    }
    
    func handleTypeChange(){
        print("MarcaSelect handleTypeChange marcaSelectType: \(marcaSelectType)")
    }
    
    /** ensures picker is refreshed - [] is problematic and ["String:String] may not be a change */
    func handleRefreshChoices(){
        print("refreshing choices ...")
        selection = "TAP_COUNT:\(tapCount)"
        choices = [selection]
    }
    
    func handleTextViewDisappeared(){
        if model.menuDoesAppear && choices.count <= 1 {
            _M.setMenuDoesAppear(false)
            print("handleTextViewDisappeared menuDoesAppear set to false");
        }
    }
    
    /** nothing works without this magic here. it's never called unless menu is opened.
     * very mysterious that way, since picker still exists as if it's showing */
    func handleTextViewAppeared(){
        if !model.menuDoesAppear {
            _M.setMenuDoesAppear(true)
            print("handleTextViewAppeared menuDoesAppear set to true");
        }
    }
    
    /** occurs only once per use unless a kludge is forced. picker will not disappear even when no choices, so not very useful! */
    func handlePickerOnAppear(){
        print("handlePickerOnAppear \(selection) ")
    }

    /** occurs only when view dismissed so ... not useful! */
    func handlePickerOnDisappear(){
        print("handlePickerOnDisappear \(selection) ")
    }

    func populateChoices(){
        choices = MarcaSelectType.getStrArr(marcaSelectType)
    }
    
    func handleTapOccurredChange(wasTapped:Bool, outsideTap:Bool){
        if wasTapped && outsideTap {
            print("handleTapOccurredChange wasTapped : \(wasTapped) and outsideTap : \(outsideTap)")
            print("handleTapOccurredChange wasTapped \(selection) ")

            tapCount = tapCount + 1
            _M.setTapOccurred(false)
            
            if !model.menuDoesAppear{
                /** call now instead of when menuDoesAppear set to false since may not be needed til now */
                populateChoices()
            }else{
                /**need to set choices to something rather than empty array, otherwise no textviews will appear*/
                refreshChoiceCount = refreshChoiceCount + 1
            }
        }
    }
}
