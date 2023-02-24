//
//  TextCreateView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//
//  struct TextCreateView: View
//  struct TextCatViewLink: View
//  struct TextCreateFields: View
//  struct CheckboxFieldView: View
//  struct TextCreateViewProxy: View
//
import Amplify
import AWSAPIPlugin
import SwiftUI

struct TextCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()
    
    @State var textTitle:String = _C.MPTY_STR
    @State var textBody:String = _C.MPTY_STR

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            NavigationView {
                List(model.textGroupCats) { cat in
                    if let catName:String = cat.name  {
                        NavigationLink(catName, destination:TextCatViewLink(textGroupCategory:cat))
                            .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                            .onAppear(perform: { print("NavigationLink onAppear ")})
                            .task{ print("NavigationLink task ") }
                    }
                }
                .padding(0)
                .font(.custom("verdana", size: 12))
                .fontWeight(.bold)
                .listStyle(.plain)
                .navigationBarTitle(_C.MPTY_STR, displayMode: .inline)
            }
            .padding(.top, 10)//for some odd reason 0 does not work at all - the view moves to the top of the safeArea!
            .accentColor(_C.marcaGray)
            .fontWeight(.bold)
            .navigationViewStyle(.stack)
            .border(Color.black, width:_D.flt(1))

            TextCreateFields(textTitle:$textTitle, textBody:$textBody)
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .onAppear(perform:TextCreateViewProxy.handleOnTextCreateViewAppear)
        .onChange(of:model.taskViewChoice, perform:{ tvc in
            if tvc != .textCreateView  { dismiss() }
        })
    }
}

struct TextCatViewLink: View {
    @StateObject var model:_M = _M.M()
    var textGroupCategory:IdentifiableGroupCategories
    
    var body: some View {
        if let title = textGroupCategory.title, let role = textGroupCategory.role{
            VStack(alignment: .center, spacing: 0){
                List(model.textGroupEmployees) { emp in
                    VStack(alignment: .center, spacing: 0){
                        if let phone = emp.phone {
                            if let empName = emp.name {
                                CheckboxFieldView(empName:empName, phone:phone)
                            }
                        }
                    }
                    .padding(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top:8, leading: 0, bottom:0, trailing: 0))
                .border(Color.black, width:_D.flt(0))
                .listStyle(PlainListStyle())
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onAppear( perform:
                        {
                Task{
                    await TextCreateViewProxy.getTextingCatEmps(title:title, role:role)
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

struct TextCreateFields: View {
    @StateObject var model:_M = _M.M()
    @FocusState private var maybeFocusedField:Field?
    
    @Binding var textTitle:String
    @Binding var textBody:String
    
    let titleField = "Input Title"
    let bodyField = "Input Text"

    var body: some View {
        
        VStack(alignment:.center, spacing:0){
            MarcaTextField(text:$textTitle, fieldName:titleField)
            MarcaTextField(text:$textBody, fieldName:bodyField, lineLimit:3...6)
            MarcaButton(action:createAndSendText, textBody:"Send Text", type:_C.BUTTON_SUBMIT, disabled:disableButton())
        }
        .padding([.leading, .trailing],10)
    }
    
    private func disableButton()->Bool{
        return model.cellPhoneDict == _C.MPTY_STRDICT || textTitle == _C.MPTY_STR || textBody == _C.MPTY_STR
    }
    
    private func createAndSendText(){
        var numList:String = _C.MPTY_STR
        var sep = _C.MPTY_STR
        let pipesep = "|"
        for (k, v) in model.cellPhoneDict {
            numList += "\(sep)\(k) @ \(v)"
            if (sep == _C.MPTY_STR) { sep = pipesep }
        }
        print("textTitle: \(textTitle), textBody: \(textBody)")
        print("numList : \(numList)")
        
        let authorInfo = "Ahearn, John @ 5102958024"
        let cellInfoList = "\(authorInfo)|\(numList)"
        print("cellInfoList = \(cellInfoList)")

        Task{
            let createSucceeded = await TextCreateViewProxy.submitTextForSend(title:textTitle, body:textBody, cellInfoList:cellInfoList)
            await handleTextCreate(success:createSucceeded)
        }
    }
    
    private func handleTextCreate(success:Bool) async{
        textTitle = _C.MPTY_STR
        textBody = _C.MPTY_STR
        await TextCreateViewProxy.handleTextCreated(success:success)
    }
}

struct CheckboxFieldView: View {
    @StateObject var model:_M = _M.M()
    @State var checkState: Bool = false

    var empName:String?
    var phone:String?
    
    var body: some View {
        Button(action:
        {
            self.checkState = !self.checkState
            print("State : \(self.checkState)")
            
            if let p = phone{
                if let e = empName{
                    print("numList initializing model.cellPhoneDict")
                    model.cellPhoneDict[e] = self.checkState ? p : nil
                }
            }
        })
        {
            HStack(alignment: .top, spacing: 10) {
                Rectangle()
                    .fill(self.checkState ? _C.marcaGreen : _C.marcaGray)
                    .frame(width:15, height:15, alignment: .center)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top:2, leading:0, bottom:0, trailing:0))
                    .onAppear( perform:
                    {
                        if let name = empName {
                            self.checkState = model.cellPhoneDict[name] != nil
                        }
                    })

                if let name = empName {
                    Text(name)
                        .font(.custom("helvetica", size:13))
                        .padding(EdgeInsets(top:0, leading:0, bottom:2, trailing:0))
                }
            }
        }
        .foregroundColor(Color.black)
    }
    
}

struct TextCreateViewProxy{
    static private var model:_M = _M.M()
    
    public static func handleTextCreated(success:Bool) async{
        if(success){
            await _M.setTaskViewChoice(.logsView) //change view before Logs update
            await LogsViewProxy.getLogs()
        }
    }
    
    public static func submitTextForSend(title:String, body:String, cellInfoList:String) async -> Bool{
        var textCreateSuccess = false
        let date = NSDate()
        let millis:String = String(Int64(date.timeIntervalSince1970 * 1000.0))
        
        let body = [
            "workLogOpWorkLogId":millis,
            "workLogType":"Log",
            "workLogTopic":"Any",
            "workLogSeverity":"text",
            "workLogShift":"PM",
            "workLogTitle":title,
            "workLogAuthor":model.user?.fullName ?? _C.MPTY_STR,
            "workLogDesc":body,
            "workLogCellInfo":cellInfoList,
            "workLogLastDesc":_C.MPTY_STR,
            "workLogReadOnly":"false",
            "workLogWorkGroup":"64",
            "employeeRoleId":"S",
            "employeeWorkGroups":"2147483647",
            "timeStr":"55",//2 days
            "typeVal":"All",
            "topicVal":"All"
        ]
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            let request = RESTRequest(
                path:"/workLogs/\(millis)/add",
                body: jsonData
            )
            
            let data = try await Amplify.API.post(request: request)
            let str = String(decoding: data, as: UTF8.self)
            print("Success: \(str)")
            textCreateSuccess = true
            
        } catch let error as APIError {
            print("Failed due to API error: ", error)
            
            if case let .httpStatusError(_, response) = error, let awsResponse = response as? AWSHTTPURLResponse {
                if let responseBody = awsResponse.body {
                    print("Response contains a \(responseBody.count) byte long response body")
                    print("awsResponse : \(awsResponse) ")
                    print("responseBody : \(responseBody) ")
                }
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return textCreateSuccess
    }
    
    public static func getTextingCatEmps(title:String, role:String) async{
        var catArr: [IdentifiableGroupEmployees] = []
        print("making RESTRequest for texting group categories ... ")
        
        //https://gely35v1j1.execute-api.us-west-2.amazonaws.com/prod/employees?cat=TimeStation&value=S&dept=all&title=on_site_admin
        
        let request = RESTRequest(path:"/employees", queryParameters: ["cat":"TimeStation", "value":role, "dept":"all", "title":title])
        
        do {
            let data = try await Amplify.API.get(request: request)
            
            if let textCatDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {
                
                if let textCats = textCatDict["employees"] as? NSArray {
                    
                    print("textCats.count = \(textCats.count)")
                    
                    let doAppend = true
                    /*DEMO ONLY
                    var prevLastinitial:String = ""
                    var lastinitial:String = "A"
                    var lastinitialCount:Int = 0
                    let lastinitialCountMax:Int = 3
                     */
                    catArr = []
                    for tCat:Any in textCats {
                        var contactInfo:String?
                        var phone:String?
                        var empName:String?
                        if let tCatD = tCat as? NSDictionary{
                            for (key,val) in tCatD{
                                if let keyStr = key as? NSString{
                                    if let val = val as? String {
                                        
                                        if (keyStr == "contactInfo"){
                                            contactInfo = val
                                            if let contactInfoArr = contactInfo?.components(separatedBy: "^~`"){
                                                if (contactInfoArr.count > 0){
                                                    phone = contactInfoArr[0] as String
                                                }
                                            }
                                            
                                        }else if (keyStr == "name"){
                                            empName = val
                                            
                                            /*DEMO ONLY
                                            lastinitial = String(describing:empName!.first)
                                            
                                            if lastinitial != prevLastinitial{
                                                lastinitialCount = 0
                                                prevLastinitial = lastinitial
                                            }else{
                                                lastinitialCount = lastinitialCount + 1
                                            }
                                            
                                            if lastinitialCount < lastinitialCountMax {
                                                doAppend = true
                                            }else{
                                                doAppend = false
                                            }
                                             */
                                        }
                                        
                                        if (phone != nil && empName != nil){
                                            let empContactDict:IdentifiableGroupEmployees = IdentifiableGroupEmployees(name: empName! ,phone:phone!)
                                            if doAppend {
                                                catArr.append(empContactDict)
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            print("getTextingCatEmps calling handleTextGroupEmpsUpdated ...")
            await handleTextGroupEmpsUpdated(emps:catArr)
            
        }catch{
            print(error)
        }
    }
    
    public static func handleTextGroupEmpsUpdated(emps : [IdentifiableGroupEmployees])async{
        await _M.updateTextGroupEmps(emps)
    }
    
    public static func handleOnTextCreateViewAppear(){
        Task{
            await _M.setCurrentViewTitle("Send Group Text")
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
        }
    }
}
