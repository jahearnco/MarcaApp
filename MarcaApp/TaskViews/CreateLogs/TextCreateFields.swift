//
//  TextCreateFields.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/23/22.
//
import SwiftUI

struct TextCreateFields: View {
    @Binding var textTitle:String
    @Binding var textBody:String

    var body: some View {
        
        VStack {
            TextField("Title", text: $textTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top:2, leading:6, bottom:2, trailing:6))
                .shadow(radius: 1)
                .border(Color.gray, width:0)

            TextField("Body", text: $textBody,  axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top:2, leading:6, bottom:2, trailing:6))
                .shadow(radius: 1)
                .border(Color.gray, width:0)
        }
        .padding(4)
        
    }
}
