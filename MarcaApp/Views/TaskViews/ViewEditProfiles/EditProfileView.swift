//
//  EditProfile.swift
//  MarcaApp
//
//  Created by Enjoy on 2/7/23.
//

import Amplify
import CoreImage.CIFilterBuiltins
import SwiftUI

struct EditProfileView: View {
    @StateObject var model:_M = _M.M()

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            NavigationView {
                List{
                    ForEach( WorkgroupCategory.profileWorkgroupCategories) { cat in
                         NavigationLink(cat.itemId, destination:ProfileCatViewLink(range:cat.range, title:cat.title))
                            .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                    }
                }
                .padding(0)
                .font(.custom("verdana", size: 12))
                .fontWeight(.bold)
                .navigationBarTitle("", displayMode: .inline)
                .listStyle(.plain)
            }
            .padding(.top, 4)//for some odd reason 0 does not work at all - the view moves to the top of the safeArea!
            .accentColor(.marcaGray)
            .fontWeight(.bold)
            .navigationViewStyle(.stack)
            .border(Color.black, width:_D.flt(1))
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .onAppear(perform: { EditProfileViewProxy.handleOnViewAppear() })
    }
}

struct ProfileCatViewLink: View {
    @StateObject var model:_M = _M.M()
    @State var range:String?
    @State var title:String?
    @State var profileGroupList:[Profile] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Spacer()
            
            List{
                ForEach (profileGroupList) { profile in
                    NavigationLink(profile.name, destination:ProfileSummaryView(selectedProfile:profile))
                        .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                        .onAppear(perform: { _D.dPrint("Edit Profiles NavigationLink onAppear ") })
                }
            }
            .font(.custom("verdana", size: 12))
            .fontWeight(.bold)
            .navigationBarTitle("", displayMode: .inline)
            .padding(0)
            .padding(EdgeInsets(top:0, leading: 0, bottom:0, trailing: 0))
            .border(Color.black, width:_D.flt(0))
            .listStyle(.plain)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .onAppear( perform:{ Task{ profileGroupList = await EditProfileViewProxy.getProfileGroupList(range:range, title:title) }})
    }
}

struct ProfileSummaryView: View {
    @StateObject var model:_M = _M.M()
    @State var selectedProfile:Profile

    var body: some View {
        VStack(alignment:.center, spacing:0){
            if let name = selectedProfile.name{
                Text(name)
                    .font(.custom("helvetica", size:16))
                    .padding(.top, -35)
                    .padding(.bottom, 7)
                
                ScrollView{
                    ProfileImages(selectedProfile:$selectedProfile)
                    ProfileContactInfo(selectedProfile:$selectedProfile)
                    ProfileStaffNotes(selectedProfile:$selectedProfile)
                }
            }
        }
        .padding(0)
        .onTapGesture { _M.setTapOccurred(true) }
    }
}

struct ProfileStaffNotes: View{
    @StateObject var model:_M = _M.M()
    @Binding var selectedProfile:Profile
    
    var body: some View{
        NotesTitle()
        ScrollView{
            VStack(alignment: .leading, spacing:0) {
                LogsView(logs:$selectedProfile.staffNotes, bodyHeight:27, outerMarginWidth:8)
                    .onAppear( perform: { Task{ selectedProfile = await EditProfileViewProxy.getPopulatedEmployeeProfile(selectedProfile) }})
            }
            .padding(0)
            .frame(height:238.0)
        }
    }
}

struct ProfileImages: View{
    @StateObject var model:_M = _M.M()
    @Binding var selectedProfile:Profile
    
    var body: some View{
        HStack(alignment:.top, spacing:0){
            VStack(alignment: .leading, spacing:0) {
                QRView(qrCode:selectedProfile.qrCode).padding(.bottom, 14)
                Spacer()
            }
            .padding(.leading, 24)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing:0) {
                BadgePhoto(photoName:selectedProfile.photoName)
                Spacer()
            }
            .padding(.trailing, 26)
        }
        .padding(.top, 0)
        .padding(.bottom, 16)
        .padding([.leading,.trailing], 0)
    }
}

struct ProfileContactInfo: View{
    @StateObject var model:_M = _M.M()
    @FocusState var maybeFocusedField:Field?
    
    @Binding var selectedProfile:Profile
    
    @State var textFieldHeight:CGFloat = 32
    @State var statusSelection:String = .emptyString
    @State var refreshChoiceCount:Int = 0
    @State var marcaSelectType:MarcaSelectType = .profileStatusChoices

    var fgColor:Color = .marcaGray
    
    var body: some View{
        HStack(alignment:.top, spacing:4){
            VStack(alignment: .center, spacing:4){
                MarcaTextField(text:$selectedProfile.email, pre:"e", fgColor:fgColor, fieldName:"Input Email Address", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                MarcaTextField(text:$selectedProfile.title, pre:"t", fgColor:fgColor, fieldName:"Input Title", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                MarcaTextField(text:$selectedProfile.currentNote, fgColor:fgColor, fieldName:"Input Staff Notes", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
            }
            .padding(0)
            .frame(width:model.appFullWidth/1.6)
            
            GeometryReader { gr in
                VStack(alignment: .center, spacing:4){
                    
                    MarcaTextField(text:$selectedProfile.phone, pre:"p", fgColor:fgColor, fieldName:"Input Phone", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                    MarcaTextField(text:$selectedProfile.salary, pre:"r", fgColor:fgColor, fieldName:"Input Salary", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                    MarcaSelect(
                        selection:$statusSelection,
                        marcaSelectType:$marcaSelectType,
                        width:gr.size.width-28,
                        height:gr.size.height/3-24,
                        key:"name",
                        selectImage: Image(systemName: "arrowtriangle.down.fill"),
                        title:$selectedProfile.currentStatus,
                        refreshChoiceCount:$refreshChoiceCount
                    )
                }
                .padding(0)
            }
        }
        .padding([.leading,.trailing], 10)
        .padding(.bottom, 24)
        .onChange(of:statusSelection, perform:{ ss in handleStatusSelectionChange(ss) } )
        .onAppear(perform:{ marcaSelectType = .profileStatusChoices })
        .onChange(of:marcaSelectType, perform:{ _ in marcaSelectType = .profileStatusChoices })
        .onChange(of:[String(describing:model.inEditingMode), selectedProfile.currentStatus,selectedProfile.currentNote], perform:{ if $0[0] == "false" { handleOnChangeNewStaffNote($0[1],$0[2]) } })
    }
    
    private func handleOnChangeNewStaffNote(_ status:String?, _ notesInput:String?){
        print("handleOnChangeNewStaffNote (status,notesInput) : \((status,notesInput))")
        if let s = status, let ni = notesInput, ni.count > 0, s != MarcaProfileStatusChoice.notselected.rawValue{
            let unformattedDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
            dateFormatter.timeZone = TimeZone(abbreviation:"MTN")
            let dateStr = dateFormatter.string(from:unformattedDate)
            
            let newStaffNote = MarcaLogItem(itemId:"\(dateStr)\(selectedProfile.staffNotes.count)", auth:model.user?.userFirstNameLastI, desc:notesInput, descNote:status, createDateStr:dateStr)
            selectedProfile.staffNotes = [newStaffNote] + selectedProfile.staffNotes //can also use joined() but ... kinda like this!

            print("handleOnChangeNewStaffNote 2 newStaffNote : \(newStaffNote)")
        }
    }
    
    private func handleStatusSelectionChange(_ selection:String){
        if let choiceCase = MarcaProfileStatusChoice(rawValue:selection) {
            print("ProfileContactInfo handleStatusSelectionChange statusSelection : \(choiceCase)")
            
            //copy values before resetting selection
            selectedProfile.currentStatus = choiceCase.rawValue

        }else{
            print("ProfileContactInfo handleStatusSelectionChange statusSelection rejected : \(selection)")
        }
        //menu has collapsed and now is time to delete choices in MarcaSelect
        refreshChoiceCount = refreshChoiceCount + 1
    }
}

struct BadgePhoto: View{
    @StateObject var model:_M = _M.M()
    @State var loading:Bool = true
    
    let photoName:String

    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0){
                AsyncImage(url: URL(string: "https://everphase.net/epi/operations/img/photos/employees/\(photoName).jpg?\(model.cacheKiller)")){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .border(Color.red,width:_D.flt(1))
                        .frame(width:160, height:160)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius:12)
                                .stroke(Color.white, lineWidth:4)
                                .shadow(color: .gray, radius:4, x: 3, y:3)
                        )
                        .onAppear(perform: { loading = false;  } )
                    
                } placeholder: {
                    Color.clear
                }
                .padding(0)
            }

            ProgressView("Loading ...")
                .opacity(loading ? 1 : 0)
        }
    }
}

struct QRView: View {
    @StateObject var model:_M = _M.M()
    
    let qrCode: String
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .frame(width:160, height:160)
                    .padding(0)
            }
        }
        .onAppear {
            generateImage()
        }
    }

    private func generateImage() {
        guard image == nil else { return }

        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(qrCode.utf8)

        guard
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else { return }

        self.image = UIImage(cgImage: cgImage)
    }
}

struct NotesTitle: View{

    var body: some View {
        HStack (alignment: .top, spacing:0){
            Text("Staff Notes")
                .font(.custom("helvetica", size:13))
                .padding(.leading, 25)
            
            Spacer()
            
            Text("Status")
                .font(.custom("helvetica", size:13))
                .padding(.trailing, 35)
        }
        .padding(.top, 14)
        .padding(.bottom, -3)
        .padding([.leading,.trailing], 0)
        .border(Color.red, width:_D.flt(1))
    }
}

struct EditProfileViewProxy:MarcaViewProxy{
    static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {

    }
    
    public static func handleOnViewDisappear(){

    }
    
    public static func formatPhone(phone:String?)->String{
        if let p = phone{
            return "\(p)"
        }else{
            return .emptyString
        }
    }
   
    public static func formatSalary(salary:String?)->String{
        if let s = salary{
            return "\(s)"
        }else{
            return .emptyString
        }
    }
    
    public static func getProfileGroupList(range:String?, title:String?)async->[Profile]{
        var profileGroupList:[Profile] = []
        if let range = range, let title = title{
            print("making RESTRequest for profile group categories ... ")
            
            let request = RESTRequest(path:"/employees", queryParameters: ["cat":"PhotoNames", "value":"g", "range":range, "dept":"all", "title":title])
            
            do {
                let data = try await Amplify.API.get(request: request)
                
                if let profileCatDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let profileCats = profileCatDict["employees"] as? NSArray{
                    _D.dPrint("profileCatDict = \(profileCatDict)")
                    print("profileCats.count = \(profileCats.count)")
                    
                    for tCat:Any in profileCats {
                        var empName:String?
                        var empId:String?
                        if let tCatD = tCat as? NSDictionary{
                            for (key,val) in tCatD{
                                if let keyStr = key as? NSString{
                                    if let val = val as? String {
                                        if (keyStr == "name"){
                                            empName = val
                                        }else if (keyStr == "employeeId"){
                                            empId = val
                                        }
                                        
                                        if let eid = empId, let en = empName {
                                            profileGroupList.append(Profile(itemId:eid, name:en))
                                            break
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
        }
        return profileGroupList
    }
    
    public static func getPopulatedEmployeeProfile(_ profile:Profile)async->Profile{
        var p = profile
        print("getEmployeeProfile making RESTRequest ... ")
        
        let body = ["employeeName":"Ahearn, John"]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        let request = RESTRequest(
            path:"/employees/\(p.itemId)",
            body: jsonData
        )
        
        do {
            let data = try await Amplify.API.post(request: request)
            
            if let pd = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {
                _D.dPrint("getEmployeeProfile profileStrDict : \(pd) ")
                
                if let notes = pd["staffingNotes"] as? [String]{
                    for noteGroup in notes{
                        if let noteGroupArr = noteGroup.components(separatedBy: "^~`") as [String]?{
                            var authStr:String = ""
                            var descStr:String = ""
                            var dateStr:String = ""
                            var status:String = ""
                            
                            var loopCount = 0
                            for noteCat in noteGroupArr{
                                if let noteArr = noteCat.components(separatedBy: "|:") as [String]?{
                                    if loopCount == 0{
                                        authStr = noteArr[0]
                                        descStr = noteArr[1]
                                    }else{
                                        status = noteArr[0]
                                        let epochMillis:Double = Double(noteArr[1]) ?? 0.0
                                        let unformattedDate = Date(timeIntervalSince1970:epochMillis/1000.0)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
                                        dateFormatter.timeZone = TimeZone(abbreviation:"MTN")
                                        dateStr = dateFormatter.string(from:unformattedDate)
                                    }
                                }
                                loopCount += 1
                            }
                            let logItem = MarcaLogItem(itemId:"\(dateStr)\(profile.staffNotes.count)", auth:authStr, desc:descStr, descNote:status, createDateStr:dateStr)
                            p.staffNotes.append(logItem)
                        }
                    }
                }
                
                p.name = pd["name"] as! String
                p.photoName = pd["photoName"] as! String
                p.title = titleCodeToTitle(code:pd["title"] as? String)
                p.qrCode = pd["qrCode"] as! String
                
                _D.dPrint("getEmployeeProfile contactInfo : \(String(describing:pd["contactInfo"])) ")
                
                if let contactInfo = pd["contactInfo"] as? String{
                    let contactInfoArr = contactInfo.components(separatedBy: "^~`")
                    let itemCount = contactInfoArr.count
                    p.phone = itemCount > 0 ? contactInfoArr[0] : .emptyString
                    p.email = itemCount > 1 ? contactInfoArr[1] : .emptyString
                    p.salary = itemCount > 2 ? contactInfoArr[2] : .emptyString
                }
            }
            
        }catch{
            print(error)
        }
        return p
    }

    public static func titleCodeToTitle(code:String?)->String{
        var retStr:String = "Chief Security Officer"
        for t in MarcaProfileTitle.allCases{
            if code == String(describing:t){
                retStr = t.rawValue
                break
            }
        }
        return retStr
    }
}
