//
//  MarcaHeader.swift
//  MarcaApp
//
//  Created by Enjoy on 2/2/23.
//

import SwiftUI

struct MarcaHeader: View {
    @StateObject var model:_M = _M.M()
    
    var body: some View {
        HStack(alignment:.bottom, spacing:0){
            LogoButton()
            Spacer()
            Title()
            Spacer()
            ActionButton()
        }
        .border(Color.red, width:_D.flt(1))
        .padding(.top,-20)
        .foregroundColor(.black)
        .fontWeight(.bold)
        .font(.custom("georgia", size: 13))
        .frame(height:model.headerHeight)
        .onChange(of:model.isPortraitOrientation, perform: { ipo in handleOrientationChange(ipo) } )
        .background(
            LinearGradient(gradient: Gradient(colors:[
                .black,
                _C.deepBlueViolet,
                .white,
                .gray.opacity(0.1)
            ]),startPoint: .top, endPoint: .bottom)
        )
        .onTapGesture { _M.setTapOccurred(true) }
    }

    func handleOrientationChange(_ isPortrait:Bool){
        let height:CGFloat = isPortrait ? _C.HEADER_HEIGHT_PORTRAIT : _C.HEADER_HEIGHT_LANDSCAPE
        _M.setHeaderHeight(height)
    }
}

struct LogoButton : View{
    @StateObject var model:_M = _M.M()
    
    var body: some View {
        Button(action:{}){
            Image("Logo_020123")
                .resizable()
                .frame(width:getLogoWidth(appFullWidth:model.appFullWidth, aspectRatio:model.appFullScreenAspectRatio), height:78.0)
        }
        .padding(EdgeInsets(top:0, leading:6, bottom:0, trailing:0))
    }
    
    func getLogoWidth(appFullWidth:CGFloat, aspectRatio:CGFloat)->CGFloat{
        let scale = aspectRatio < 1.0 ? 0.33 : 0.24
        return appFullWidth*scale
    }
}

struct Title : View{
    @StateObject var model:_M = _M.M()
    
    var body: some View {
        HStack(alignment:.bottom, spacing:0){
            Text(getTitleString(isLoggedIn:model.isUserLoggedIn, currentViewTitle:model.currentViewTitle))
                .font(getFont(isLoggedIn:model.isUserLoggedIn))
                .foregroundColor(_C.marcaGray)
                .padding(0)
        }
        .padding(getEdgeInsets(model.isUserLoggedIn))
        .border(Color.green, width:_D.flt(1))
    }
    
    func getFont(isLoggedIn:Bool)->Font{
        return isLoggedIn ? Font.custom("Optima-Bold", size:17) : Font.custom("Optima-Bold", size:19)
    }
    
    func getTitleString(isLoggedIn:Bool, currentViewTitle:String?)->String{
        return isLoggedIn ? currentViewTitle ?? _C.MPTY_STR : "MARCA"
    }
    
    func getEdgeInsets(_ isLoggedIn:Bool)->EdgeInsets{
        return isLoggedIn ? EdgeInsets(top:0, leading: 0, bottom:-1, trailing:20) : EdgeInsets(top:0, leading: 0, bottom:-1, trailing:0)
    }
}

struct ActionButton : View{
    @StateObject var model:_M = _M.M()
    
    @State var preferenceSelection:[String:String] = _C.MPTY_STRDICT
    @State var refreshChoiceCount:Int = 0
    @State var menuTitle:String = ""
    @State var selectType:MarcaSelectType = .loginMenuChoices
    
    var body: some View {
        MarcaSelect(
            selection:$preferenceSelection,
            type:$selectType,
            width:getFrameSize(model.isUserLoggedIn).0,
            height:getFrameSize(model.isUserLoggedIn).1,
            key:"name",
            imageWidth:22.0,
            imageHeight:22.0,
            selectImage: getImage(model.isUserLoggedIn),
            strokeColor:Color.clear,
            bgColor:Color.clear,
            title:$menuTitle,
            refreshChoiceCount:$refreshChoiceCount
        )
        .padding(EdgeInsets(top:0, leading:0, bottom:-6, trailing:12))
        .onChange(of:preferenceSelection, perform:{ ps in handlePreferenceSelectionChange(ps) } )
        .onChange(of:model.taskViewChoice, perform: { tvc in getMarcaSelectType(tvc) })
        .onChange(of:model.isUserLoggedIn, perform: { iuli in getMarcaSelectType(model.taskViewChoice) })
    }
    
    func getMarcaSelectType(_ taskView:MarcaViewChoice){
        print("getMarcaSelectType taskView: \(taskView)")
        if model.isUserLoggedIn {
            switch taskView {
            case .loginView:
                selectType = .loginMenuChoices
                
            case .editProfileView:
                selectType = .editProfilesMenuChoices
                
            case .logsView:
                selectType = .logsViewMenuChoices
                
            case .textCreateView:
                selectType = .createTextMenuChoices
                
            default:
                selectType = .loginMenuChoices
            }
        }else{
            selectType = .loginMenuChoices
        }
    }
    
    func getImage(_ loggedIn:Bool)->Image{
        return loggedIn ? Image(systemName: "slider.horizontal.3") : Image(systemName: "line.3.horizontal")
    }
    
    func handlePreferenceSelectionChange(_ selection:[String:String]){
        //menu has collapsed and now is time to delete choices in MarcaSelect
        refreshChoiceCount = refreshChoiceCount + 1
    }
    
    func getFrameSize(_ isUserLoggedIn:Bool)->(CGFloat,CGFloat){
        return isUserLoggedIn ? (28.0, 22.0) : (28.0, 22.0)
    }
}
