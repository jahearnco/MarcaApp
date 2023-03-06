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

import Amplify
import AWSAPIPlugin
import SwiftUI

struct TextCreateView: View {
    @StateObject var model:_M = _M.M()
    
    @State var textTitle:String = ""
    @State var textBody:String = ""
    @State var selectedProfileHash:[String:Profile] = [String:Profile]()

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            NavigationView {
                List{
                    ForEach(WorkgroupCategory.textingWorkgroupCategories) { cat in
                        NavigationLink(cat.itemId, destination:TextCatViewLink(title:cat.title, role:cat.role, selectedProfileHash:$selectedProfileHash))
                             .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                    }
                }
                .padding(0)
                .font(.custom("verdana", size: 12))
                .fontWeight(.bold)
                .listStyle(.plain)
                .navigationBarTitle("", displayMode: .inline)
            }
            .padding(.top, 10)//for some odd reason 0 does not work at all - the view moves to the top of the safeArea!
            .accentColor(Color.marcaGray)
            .fontWeight(.bold)
            .navigationViewStyle(.stack)
            .border(Color.black, width:_D.flt(1))

            TextCreateFields(textTitle:$textTitle, textBody:$textBody, selectedProfileHash:$selectedProfileHash)
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .onAppear(perform: { TextCreateViewProxy.handleOnViewAppear() })
        .onDisappear(perform: { _D.dPrint("TextCreateView disappeared") })
    }
}

struct TextCreateFields: View {
    @StateObject var model:_M = _M.M()
    @FocusState private var focusedField: TextCreateFields.Field?
    
    @Binding var textTitle:String
    @Binding var textBody:String
    @Binding var selectedProfileHash:[String:Profile]
    
    @State var titleField:String = "Input Title"
    @State var bodyField:String = "Input Text"

    var body: some View {
        
        VStack(alignment:.center, spacing:0){
            MarcaTextField(text:$textTitle, fieldName:titleField)
                .focused($focusedField, equals: .inputTitleField)
            
            MarcaTextField(text:$textBody, fieldName:bodyField, lineLimit:3...6, submitAction:doSubmit)
                .focused($focusedField, equals: .inputBodyField)
            
            MarcaButton(action:doSubmit, textBody:"Send Text", type:.buttonSubmit, disabled:disableButton())
            
        }
        .submitScope(true)
        .padding([.leading, .trailing], 5)
        .onDisappear(perform: { _D.dPrint("TextCreateFields disappeared") })
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer().frame(width:model.appFullWidth - 100)
            }
            ToolbarItem(placement: .keyboard) {
                Button(action: focusPreviousField) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canFocusPreviousField()) // remove this to loop through fields
                .padding(.trailing,10)
            }
            ToolbarItem(placement: .keyboard) {
                Button(action: focusNextField) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canFocusNextField()) // remove this to loop through fields
            }
        }
    }
    
    private func disableButton()->Bool{
        return selectedProfileHash.count == 0 || textTitle == .emptyString || textBody == .emptyString
    }
    
    public func doSubmit(){
        TextCreateViewProxy.createAndSendText(selectedProfileHash:selectedProfileHash, user:model.user, title:textTitle, body:textBody)
    }
}

extension TextCreateFields {
    /*
     move all this to MarcaTextField
     idea should be that @FocusState uses this enum throughout the app for field
     then you can see which actuial field has focus, and maybe control nil values as well?
     */
    
    private enum Field: Int, CaseIterable {
        case inputTitleField
        case inputBodyField
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .inputTitleField
        }
    }

    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .inputBodyField
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }

    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}

/*
 struct ContentView: View {
     @Environment(\.firstResponder) private var firstResponder: ObjectIdentifier
     @State var text1: String = ""
     @State var text2: String = ""
     var body: some View {
         VStack {
             TextField("...", text: self.$text1)
                 .id("TF1")
             TextField("...", text: self.$text2)
                 .id("TF2")
             HStack {
                 Button("Focus 1") {
                     self.firstResponder = "TF1"
                 }
                 Button("Focus 2") {
                     self.firstResponder = "TF2"
                 }
             }
         }
     }
 }
 */
struct CheckboxFieldView: View {
    @StateObject var model:_M = _M.M()
    @State var checkState: Bool = false
    @State var profile:Profile?
    @Binding var selectedProfileHash:[String:Profile]
    
    var body: some View {
        Button(action:
        {
            handleCheckboxPressAction()
        })
        {
            HStack(alignment: .top, spacing: 10) {
                if let name = profile?.name {
                    Rectangle()
                        .fill(self.checkState ? Color.marcaGreen : Color.marcaGray)
                        .frame(width:15, height:15, alignment: .center)
                        .cornerRadius(5)
                        .padding(EdgeInsets(top:2, leading:0, bottom:0, trailing:0))
                        .onAppear( perform:{ handleCheckboxOnAppear(name) })
                    
                    Text(name)
                        .font(.custom("helvetica", size:13))
                        .padding(EdgeInsets(top:0, leading:0, bottom:2, trailing:0))
                }
            }
        }
        .foregroundColor(Color.black)
        .onDisappear(perform: { _D.dPrint("CheckboxFieldView disappeared") })
    }
    
    private func handleCheckboxPressAction(){
        self.checkState = !self.checkState
        print("State : \(self.checkState)")
        
        if let key = profile?.name{
            if self.checkState && !isProfileSelected(key){
                selectedProfileHash[key] = profile
            }else if isProfileSelected(key){
                selectedProfileHash.removeValue(forKey:key)
            }
        }
    }
    
    private func handleCheckboxOnAppear(_ key:String?){
        self.checkState = isProfileSelected(key)
    }
    
    private func isProfileSelected(_ key:String?)->Bool{
        var retVal = false
        do{
            retVal = try MarcaItemHashManager.exists(selectedProfileHash, key)
        }catch{
            print(error)
        }
        return retVal
    }
}

struct TextCatViewLink: View {
    @StateObject var model:_M = _M.M()
    @State var title:String?
    @State var role:String?
    @Binding var selectedProfileHash:[String:Profile]
    @State var profileGroupList:[Profile] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            List{
                ForEach(profileGroupList) { profile in
                    VStack(alignment: .center, spacing: 0){
                        CheckboxFieldView(profile:profile, selectedProfileHash:$selectedProfileHash)
                    }
                    .padding(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                    .onDisappear(perform: { _D.dPrint("TextCatViewLinkVStack disappeared") })
                }
            }
            .padding(EdgeInsets(top:8, leading: 0, bottom:0, trailing: 0))
            .border(Color.black, width:_D.flt(0))
            .listStyle(PlainListStyle())
            .onDisappear(perform: { _D.dPrint("TextCatViewLinkList disappeared") })
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .onAppear(perform: { Task{ profileGroupList = await TextCreateViewProxy.handleOnTextCatViewLinkAppear(title:title, role:role) } })
        .onDisappear(perform: { _D.dPrint("TextCatViewLink disappeared") })
    }
}

struct TextCreateViewProxy:MarcaViewProxy{
    public static func handleOnViewDisappear(){
        //dismiss()
    }
    
    static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {
        _D.dPrint("TextCreateView onAppear")
    }
    
    static func createAndSendText(selectedProfileHash:[String:Profile], user:User?, title:String, body:String){
        Task{
            let createSucceeded = await submitTextForSend(selectedProfileHash:selectedProfileHash, user:user, title:title, body:body)
            if(createSucceeded){
                await _M.setTaskViewChoice(.logsView)
            }
        }
    }
    
    static func handleOnTextCatViewLinkAppear(title:String?, role:String?)async->[Profile]{
        var retArr:[Profile] = []
        if let title = title, let role = role{
            retArr = await TextCreateViewProxy.getTextingProfileGroupList(title:title, role:role)
            _D.dPrint("CatViewLink title = \(title) .onAppear called")
        }
        return retArr
    }
    
    public static func submitTextForSend(selectedProfileHash:[String:Profile], user:User?, title:String, body:String) async -> Bool{
        //user:model.user, title:textTitle, body:textBody, cellInfoList:cellInfoList
        //print("selectedProfileHash : \(selectedProfileHash)")
        var numList:String = .emptyString
        var sep = String.emptyString
        let pipesep = "|"
        for (name, profile) in selectedProfileHash {
            numList += "\(sep)\(name) @ \(profile.phone)"
            if (sep == .emptyString) { sep = pipesep }
        }
        //print("numList : \(numList)")
        
        let authorInfo = "Ahearn, John @ 510-295-8024"
        let cellInfoList = "\(authorInfo)|\(numList)"
        _D.dPrint("cellInfoList = \(cellInfoList)")

        var textCreateSuccess = false
        let date = NSDate()
        let millis:String = String(Int64(date.timeIntervalSince1970 * 1000.0))
        let fullName = user?.fullName ?? .emptyString
        
        let body = [
            "workLogOpWorkLogId":millis,
            "workLogType":"Log",
            "workLogTopic":"Any",
            "workLogSeverity":"text",
            "workLogShift":"PM",
            "workLogTitle":title,
            "workLogAuthor":fullName,
            "workLogDesc":body,
            "workLogCellInfo":cellInfoList,
            "workLogLastDesc":.emptyString,
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
    
    public static func getTextingProfileGroupList(title:String, role:String) async ->[Profile]{
        var profileGroupList:[Profile] = []
        print("making RESTRequest for texting group categories ... ")
        
        //https://gely35v1j1.execute-api.us-west-2.amazonaws.com/prod/employees?cat=TimeStation&value=S&dept=all&title=on_site_admin
        
        let request = RESTRequest(path:"/employees", queryParameters: ["cat":"TimeStation", "value":role, "dept":"all", "title":title])
        
        do {
            let data = try await Amplify.API.get(request: request)
            
            if let textCatDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {
                
                if let textCats = textCatDict["employees"] as? NSArray {
                    
                    print("textCats.count = \(textCats.count)")
                    
                    /*DEMO ONLY
                    var prevLastinitial:String = ""
                    var lastinitial:String = "A"
                    var lastinitialCount:Int = 0
                    let lastinitialCountMax:Int = 3
                     */
                    for tCat:Any in textCats {
                        var contactInfo:String?
                        var phone:String?
                        var empName:String?
                        var itemId:String?
                        if let tCatD = tCat as? NSDictionary{
                            for (key,val) in tCatD{
                                if let keyStr = key as? NSString{
                                    if let val = val as? String {
                                        
                                        if (keyStr == "employeeId"){
                                            itemId = val
                                            
                                        }else if (keyStr == "contactInfo"){
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
                                        
                                        if let phone = phone, let empName = empName, let itemId = itemId{
                                            profileGroupList.append(Profile(itemId:itemId, name: empName, phone:phone))
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }catch{
            print(error)
        }
        return profileGroupList
    }
}

extension View {
    /// Focuses next field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a next field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }

    /// Focuses previous field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a previous field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
}
