//
//  MarcaLogView.swift
//  MarcaApp
//
//  Created by Enjoy on 2/13/23.
//
import Amplify
import SwiftUI

struct MarcaLogView: View{
    @StateObject var model:_M = _M.M()

    @State var logItem:MarcaLogItem
    
    var bgColor:Color = .marcaLightGray
    var bodyHeight:CGFloat = 86
    var outerMarginWidth:CGFloat = 16

    var body: some View{
        VStack(alignment:.center, spacing:0){
            VStack(alignment:.center, spacing:0){
                LogTitle(logItem:logItem)
                LogBody(logItem:logItem, height:bodyHeight)
            }
            .padding(.bottom,10)
            .padding([.top,.leading,.trailing], 0)
            .border(Color.green, width:_D.flt(1))
            .background(Color.white, in:RoundedRectangle(cornerRadius:8))
        }
        .padding(.top, 0)
        .padding(.bottom, outerMarginWidth)
        .padding([.leading,.trailing], outerMarginWidth)
        .listRowInsets(EdgeInsets(top:0, leading:0, bottom:0, trailing:0))
        .border(Color.red, width:_D.flt(1))
        .background(bgColor)
        .listRowSeparator(.hidden)
        .onAppear(perform:{_D.dPrint("MarcaLogView onAppear")})
    }
}

struct LogTitle: View{
    @State var logItem:MarcaLogItem
    
    var body: some View {
        HStack (alignment: .top){
            VStack(alignment:.leading, spacing:0){
                if let title = logItem.title, title.count > 0{
                    Text(title)
                        .foregroundColor(.marcaGray)
                        .font(.custom("verdana", size:10))
                        .fontWeight(.semibold)
                        .padding(0)
                }

                if let dateStr = logItem.createDateStr, dateStr.count > 0 {
                    Text(MarcaLogViewProxy.formatTitleDate(dateStr:dateStr))
                        .foregroundColor(.marcaDarkGray)
                        .font(.custom("consolas", size:12))
                        .fontWeight(.regular)
                        .padding(0)
                }

                Spacer()
            }
            
            Spacer()
            
            VStack(alignment:.trailing, spacing:0){
                if let auth = logItem.auth, auth.count > 0 {
                    Text(CognitoProxy.getUserFirstNameLastI(fullName:auth) ?? .emptyString)
                        .foregroundColor(.marcaGray)
                        .font(.custom("verdana", size:10))
                        .fontWeight(.semibold)
                        .padding(0)
                }
                
                if let dateStr = logItem.createDateStr, dateStr.count > 0 {
                    Text(MarcaLogViewProxy.formatTitleDate(dateStr:dateStr))
                        .foregroundColor(.marcaDarkGray)
                        .font(.custom("consolas", size:12))
                        .fontWeight(.regular)
                        .padding(0)
                }

                Spacer()
            }
            .padding(0)
        }
        .padding(.top, 4)
        .padding(.bottom, 0)
        .padding([.leading,.trailing], 10)
        .border(Color.red, width:_D.flt(1))
        .onAppear(perform:{_D.dPrint("LogTitle onAppear")})
    }
}

struct LogBody: View{
    @StateObject var model:_M = _M.M()
    
    @State var logItem:MarcaLogItem
    @State var height:CGFloat
    
    var body: some View {
        HStack (alignment: .top){
            //LeftArrow()
            //    .padding([.top,.bottom,.trailing], 0)
            //    .padding(.leading,-6)
            
            ScrollView{
                HStack(alignment:.top){
                    if let desc = logItem.desc {
                        Text(desc)
                            .padding(5)
                            .border(Color.black, width:_D.flt(1))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    if let descNote = logItem.descNote {
                        Text(descNote)
                            .padding([.top,.bottom,.trailing],5)
                            .padding(.leading, 0)
                            .border(Color.black, width:_D.flt(1))
                            .fontWeight(Font.Weight.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding(0)
                .border(Color.blue, width:_D.flt(1))
            }
            .padding([.top,.bottom], 0)
            .padding([.leading,.trailing], 3)
            .fontWeight(.regular)
            .font(.custom("helvetica", size:13))
            .border(Color.red, width:_D.flt(1))
            .frame(height:height)
            .background(Color.marcaLightGray.opacity(0.4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.deepBlueViolet.opacity(0.6), lineWidth:2)
                    .shadow(color: .gray, radius:1.5, x: 1.5, y:1.5)
            )

            //RightArrow()
            //    .padding([.top,.bottom,.leading], 0)
            //    .padding(.trailing,-6)
        }
        .padding(.top, 0)
        .padding(.bottom, 4)
        .padding([.leading,.trailing], 9)
        .border(Color.green, width:_D.flt(1))
        .onAppear(perform:{_D.dPrint("LogBody onAppear")})
    }
    
    struct LeftArrow: View{
        var body: some View {
            Image(systemName: "arrowtriangle.right.fill")
                .resizable()
                .frame(width:12.0, height:24.0)
                .foregroundColor(.blueVioletFuchsia.opacity(0.8))
                .padding(0)
        }
    }

    struct RightArrow: View{
        var body: some View {
            Image(systemName: "arrowtriangle.left.fill")
                .resizable()
                .frame(width:12.0, height:24.0)
                .foregroundColor(.blueVioletFuchsia.opacity(0.8))
                .padding(0)
        }
    }

}

struct MarcaLogViewProxy:MarcaViewProxy{
    public static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {

    }

    public static func handleOnViewDisappear(){

    }
    
    public static func formatTitleDate(dateStr:String)->String{
        return dateStr
    }
}
