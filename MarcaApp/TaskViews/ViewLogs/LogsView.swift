//
//  LogsView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct LogsView: View {
    @StateObject var dataModel:DataModel = DataModel.DM()
    
    var body: some View {
        List(dataModel.logs, id: \.self) { logDict in
            VStack{
                HStack (alignment: .top){
                    if let title = logDict["title"] {
                        Text(title)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.custom("helvetica", size: 12))
                    }
                    
                    Spacer()
                    
                    if let auth = logDict["auth"] {
                        Text("by \(auth)")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .font(.custom("verdana", size: 10))
                        //.frame(maxWidth:.infinity, alignment: .leading)
                    }
                }
                .padding(0)
                
                HStack(alignment: .top){
                    if let desc = logDict["desc"] {
                        Text(desc)
                            .foregroundColor(.black)
                            .fontWeight(.regular)
                            .font(.custom("helvetica", size: 11))
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top:2, leading: 15, bottom:0, trailing:0))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .border(Color.black, width:0)
        .listStyle(PlainListStyle())
    }
}
