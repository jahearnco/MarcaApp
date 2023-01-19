//
//  TextCreateView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI

struct TextCreateView: View {
    @StateObject var dataModel:DataModel = DataModel.DM()
    
    @State var cellNums:[String:String]?
    @State var textTitle:String = ""
    @State var textBody:String = ""
    @State private var showingNavView = false

    var body: some View {

        VStack(alignment: .center, spacing: 0){
            GeometryReader { gp7 in
                VStack (alignment: .center, spacing: 0){
                    NavigationStack {
                        List(dataModel.textGroupCats, id: \.self) { cat in
                            if let catName:String = cat["name"]  {
                                NavigationLink(catName, destination:CatViewLink(cellNums:$cellNums, textGroupCategory:cat))
                                    .padding(4)
                                    .onAppear(perform: { print("NavigationLink onAppear ")})
                                    .task{ print("NavigationLink task ") }
                            }
                        }
                        .font(.custom("verdana", size: 11))
                        .fontWeight(.bold)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .border(Color.black, width:0)
                    .listStyle(PlainListStyle())
                    .frame(height:gp7.size.height-165)

                    TextCreateFields(textTitle: $textTitle, textBody: $textBody)
                        .font(.custom("verdana", size: 14))
                        .padding(4)
                    
                    Button(action: createAndSendText){
                        Text("Send Text")
                            .font(.custom("verdana", size: 14))
                            .padding(EdgeInsets(top:4, leading:10, bottom:4, trailing: 10))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.purple)
                    )
                    .foregroundColor(.white)
                    .padding(0)
                    
                }
            }
        }
    }
    
    func createAndSendText(){
        if let cNums = self.cellNums{
            var numList:String = ""
            var sep = ""
            let pipesep = "|"
            for (k, v) in cNums {
                numList += "\(sep)\(k) @ \(v)"
                if (sep == "") { sep = pipesep }
            }
            print("textTitle: \(textTitle), textBody: \(textBody)")
            print("numList : \(numList)")
            
            let authorInfo = "Ahearn, John @ 5102958024"
            let cellInfoList = "\(authorInfo)|\(numList)"
            print("cellInfoList = \(cellInfoList)")

            Task{
                let createSucceeded = await FlowController.submitTextForSend(title:textTitle, body:textBody, cellInfo:cellInfoList)
                await handleTextCreate(success:createSucceeded)
            }
        }
    }
    
    func handleTextCreate(success:Bool) async{
        textTitle = ""
        textBody = ""
        await FlowController.handleTextCreated(success:success)
    }
}

struct CatViewLink: View {
    @Binding var cellNums:[String:String]?
    @StateObject var dataModel:DataModel = DataModel.DM()
    var textGroupCategory:[String:String]
    
    var body: some View {
        if let title = textGroupCategory["title"]{
            if let role = textGroupCategory["role"]{

                VStack (alignment: .center, spacing: 0){
                    List(dataModel.textGroupEmployees, id: \.self) { empDict in
                        VStack{
                            if let phone = empDict["phone"] {
                                if let empName = empDict["name"] {
                                    CheckboxFieldView(cellNums:$cellNums, empName:empName, phone:phone)
                                        .onAppear(perform: {
                                            //print("CheckboxFieldView onAppear : \(empName)")
                                            if let cNums = cellNums {
                                                for (name,_) in cNums{
                                                    if empName == name {
                                                        
                                                    }else{
                                                        
                                                    }
                                                }
                                            }
                                            
                                        }
                                    )
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .border(Color.black, width:0)
                    .listStyle(PlainListStyle())
                    
                }
                .onAppear( perform:
                {
                    Task{
                        await FlowController.getTextingCatEmps(title:title, role:role)
                        print("CatViewLink title = \(title) .onAppear called")
                    }
                })
                .onDisappear( perform:
                {
                    print("CatViewLink title = \(title) .onDisAppear called")
                })
            }
        }
    }
}
