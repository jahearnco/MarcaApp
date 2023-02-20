//
//  EditProfile.swift
//  MarcaApp
//
//  Created by Enjoy on 2/7/23.
//

import Amplify
import CoreImage.CIFilterBuiltins
import SwiftUI

struct Profile{
    var name:String = _C.MPTY_STR
    var photoName:String = _C.MPTY_STR
    var phone:String = _C.MPTY_STR
    var email:String = _C.MPTY_STR
    var salary:String = _C.MPTY_STR
    var title:String = _C.MPTY_STR
    var qrCode:String = _C.MPTY_STR
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()

    init(){
        _D.debug = false
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            NavigationView {
                    List(model.profileGroupCats, id: \.self) { cat in
                        if let catName:String = cat["name"]  {
                            NavigationLink(catName, destination:ProfileCatViewLink(profileGroupCategory:cat))
                                .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                                .onAppear(perform: { print("Edit Profiles NavigationLink onAppear ")})
                        }
                    }
                    .padding(0)
                    .font(.custom("verdana", size: 12))
                    .fontWeight(.bold)
                    .navigationBarTitle(_C.MPTY_STR, displayMode: .inline)
                    .listStyle(.plain)
            }
            .padding(.top, 4)//for some odd reason 0 does not work at all - the view moves to the top of the safeArea!
            .accentColor(_C.marcaGray)
            .fontWeight(.bold)
            .navigationViewStyle(.stack)
            .border(Color.black, width:_D.flt(1))
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .onAppear(perform: EditProfileViewProxy.handleOnEditProfileViewAppear)
        .onChange(of:model.taskViewChoice, perform:{ tvc in
            if tvc != .editProfileView {
                EditProfileViewProxy.handleDismiss(dismiss)
            }
        })
        
    }
}

struct ProfileSummaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()
    @State var empId:String

    var body: some View {
        VStack(alignment:.center, spacing:0){
            Text(model.profile.name)
                .font(.custom("helvetica", size:16))
                .padding(.top, -35)
                .padding(.bottom, 7)
            
            ScrollView{
                ProfileImages()
                ProfileContactInfo()
                ProfileStaffNotes()
            }
        }
        .padding(0)
        .onAppear( perform: {
            Task{
                //no idea why this is needed but it is! this view is not being dismissed apparently
                if model.taskViewChoice == .editProfileView{
                    await EditProfileViewProxy.getEmployeeProfile(empId:empId)
                    print("ProfileSummaryView .onAppear model.profileStaffNotes:\(String(describing:model.profileStaffNotes))")
                }
            }
        } )
        .onTapGesture { _M.setTapOccurred(true) }
    }
}

struct ProfileStaffNotes: View{
    @StateObject var model:_M = _M.M()
    @State var staffNotesHeight:CGFloat = 238.0//tried to set height programmatically : a hard to maintain complicated mess
    
    var body: some View{
        NotesTitle()
        ScrollView{
            VStack(alignment: .leading, spacing:0) {
                LogsView(bodyHeight:27, outerMarginWidth:8)
            }
            .padding(0)
            .frame(height:staffNotesHeight)
        }
    }
}
struct ProfileImages: View{
    @StateObject var model:_M = _M.M()
    
    var body: some View{
        HStack(alignment:.top, spacing:0){
            VStack(alignment: .leading, spacing:0) {
                QRView(qrCode:model.profile.qrCode).padding(.bottom, 14)
                Spacer()
            }
            .padding(.leading, 24)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing:0) {
                BadgePhoto(photoName:model.profile.photoName)
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
    
    @State var textFieldHeight:CGFloat = 32
    @State var notesInput:String = ""
    @State var statusSelection:[String:String] = _C.MPTY_STRDICT
    @State var refreshChoiceCount:Int = 0
    @State var profileStatus:String = "Status"
    @State var selectType:MarcaSelectType = .editProfilesMenuChoices
    
    var fgColor:Color = _C.marcaGray
    
    var body: some View{
        HStack(alignment:.top, spacing:4){
            VStack(alignment: .center, spacing:4){
                MarcaTextField(text:$model.profile.email, pre:"e", fgColor:fgColor, fieldName:"Input Email Address", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                MarcaTextField(text:$model.profile.title, pre:"t", fgColor:fgColor, fieldName:"Input Title", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                MarcaTextField(text:$notesInput, fgColor:fgColor, fieldName:"Input Staff Notes", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
            }
            .padding(0)
            .frame(width:model.appFullWidth/1.6)
                
            GeometryReader { gr in
                VStack(alignment: .center, spacing:4){
                    
                    MarcaTextField(text:$model.profile.phone, pre:"p", fgColor:fgColor, fieldName:"Input Phone", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                    MarcaTextField(text:$model.profile.salary, pre:"r", fgColor:fgColor, fieldName:"Input Salary", fontSize:16, fontWeight:Font.Weight.semibold, bunPadding:4, sidePadding:0)
                    MarcaSelect(
                        selection:$statusSelection,
                        type:$selectType,
                        width:gr.size.width-28,
                        height:gr.size.height/3-24,
                        key:"name",
                        selectImage: Image(systemName: "arrowtriangle.down.fill"),
                        title:$profileStatus,
                        refreshChoiceCount:$refreshChoiceCount
                    )
                }
                .padding(0)
            }
        }
        .padding([.leading,.trailing], 10)
        .padding(.bottom, 24)
        .onChange(of:statusSelection, perform:{ ss in handleStatusSelectionChange(ss) } )
        .onAppear(perform:{ selectType = .profileStatusChoices })
        .onChange(of:selectType, perform:{ s in selectType = .profileStatusChoices })
    }
    
    func handleStatusSelectionChange(_ selection:[String:String]){
        if let enumCase = MarcaProfileStatusChoice(rawValue:selection["name"] ?? "") {
            print("ProfileContactInfo handleStatusSelectionChange statusSelection : \(enumCase)")
            
            //copy values before resetting selection
            profileStatus = enumCase.rawValue
            
            //save notes here
            print("saving profileStatus \(profileStatus) and notesInput \(notesInput) ... ")
            
            let unformattedDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
            dateFormatter.timeZone = TimeZone(abbreviation:"MTN")
            let dateStr = dateFormatter.string(from:unformattedDate)
            
            let newStaffNote:[String:String] = ["auth":model.user?.userFirstNameLastI ?? "", "desc":notesInput, "profileNoteDateStr":dateStr, "descNote":profileStatus]
            var newStaffNotes:[[String:String]] = [newStaffNote]
            for notes in model.profileStaffNotes{
                newStaffNotes.append(notes)
            }

            _M.updateProfileStaffNotes(newStaffNotes)
            _M.updateLogs(model.profileStaffNotes)

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

struct ProfileCatViewLink: View {
    @StateObject var model:_M = _M.M()
    var profileGroupCategory:[String:String]

    var body: some View {
        if let range = profileGroupCategory["range"], let title = profileGroupCategory["title"]{
            
            VStack(alignment: .center, spacing: 0){
                Spacer()
                
                List(model.profileGroupEmployees, id: \.self) { empDict in
                    if let empId = empDict["id"], let empName = empDict["name"]  {
                        NavigationLink(empName, destination:ProfileSummaryView(empId:empId))
                            .padding(EdgeInsets(top:0, leading:4, bottom:0, trailing:0))
                            .onAppear(perform: { print("Edit Profiles NavigationLink onAppear ")})
                    }
                }
                .font(.custom("verdana", size: 12))
                .fontWeight(.bold)
                .navigationBarTitle(_C.MPTY_STR, displayMode: .inline)
                .padding(0)
                .padding(EdgeInsets(top:0, leading: 0, bottom:0, trailing: 0))
                .border(Color.black, width:_D.flt(0))
                .listStyle(.plain)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onAppear( perform:{ EditProfileViewProxy.getProfileCatEmps(range:range, title:title) })
        }
    }
}

struct EditProfileViewProxy{
    static var model:_M = _M.M()
    
    public static func formatPhone(phone:String?)->String{
        if let p = phone{
            return "\(p)"
        }else{
            return _C.MPTY_STR
        }
    }
   
    public static func formatSalary(salary:String?)->String{
        if let s = salary{
            return "\(s)"
        }else{
            return _C.MPTY_STR
        }
    }
    
    public static func getProfileCatEmps(range:String, title:String){
        Task{
            var catArr: [[String: String]] = _C.MPTY_STRDICT_ARRAY
            print("making RESTRequest for profile group categories ... ")
            
            let request = RESTRequest(path:"/employees", queryParameters: ["cat":"PhotoNames", "value":_C.MPTY_STR, "range":range, "dept":"all", "title":title])
            
            do {
                let data = try await Amplify.API.get(request: request)
                
                if let profileCatDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    print("profileCatDict = \(profileCatDict)")
                    
                    if let profileCats = profileCatDict["employees"] as? NSArray {
                        
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
                                                catArr.append(["name":en, "id":eid])
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                print("getProfileCatEmps calling handleProfileGroupEmpsUpdated ...")
                await handleProfileGroupEmpsUpdated(emps:catArr)
                
            }catch{
                print(error)
            }
        }
    }
    
    public static func getEmployeeProfile(empId:String) async {

        guard let _ = model.user else{
            print("cannot get profile - user is nil")
            return
        }
        
        print("getEmployeeProfile making RESTRequest ... ")

        let body = ["employeeName":"Ahearn, John"]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        let request = RESTRequest(
            path:"/employees/\(empId)",
            body: jsonData
        )

        do {
            let data = try await Amplify.API.post(request: request)
            
            if let pd = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {
                print("getEmployeeProfile profileStrDict : \(pd) ")
                
                print("getEmployeeProfile contactInfo : \(String(describing:pd["contactInfo"])) ")
                
                let contactInfo = pd["contactInfo"] as? String
                var staffNotes:[[String:String]] = []
                
                if let notes = pd["staffingNotes"] as? [String]{
                    for noteGroup in notes{
                        if let noteGroupArr = noteGroup.components(separatedBy: "^~`") as [String]?{
                            var authStr:String?
                            var descStr:String?
                            var dateStr:String?
                            var status:String?
                            
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
                            staffNotes.append(["auth":authStr ?? "", "desc":descStr ?? "", "profileNoteDateStr":dateStr ?? "", "descNote":status ?? ""])
                        }
                        print("staffNotes = \(staffNotes)")
                    }

                }
                
                var profile:Profile = Profile()
                if let contactInfoArr = contactInfo?.components(separatedBy: "^~`"){
                    let itemCount = contactInfoArr.count
                    profile = Profile(
                        name:pd["name"] as? String ?? _C.MPTY_STR,
                        photoName:pd["photoName"] as? String ?? _C.MPTY_STR,
                        phone:itemCount > 0 ? contactInfoArr[0] : _C.MPTY_STR,
                        email:itemCount > 1 ? contactInfoArr[1] : _C.MPTY_STR,
                        salary:itemCount > 2 ? contactInfoArr[2] : _C.MPTY_STR,
                        title:titleCodeToTitle(code:pd["title"] as? String),
                        qrCode:pd["qrCode"] as? String ?? _C.MPTY_STR
                    )
                }
                
                await _M.updateProfileStaffNotes(staffNotes)
                await _M.updateLogs(model.profileStaffNotes)
                await _M.setProfile(profile)
                
                /*
                for prop:Any in pd {
                    print("getEmployeeProfile prop : \(prop) ")
                }
                */
            }

        }catch{
            print(error)
        }
    }

    public static func titleCodeToTitle(code:String?)->String{
        var retStr:String? = "Chief Security Officer"
        for t in MarcaProfileTitle.allCases{
            if code == String(describing:t){
                retStr = t.rawValue
                break
            }
        }
        return retStr ?? ""
    }
    
    public static func handleProfileGroupEmpsUpdated(emps : [[String:String]])async{
        await _M.updateProfileGroupEmployees(emps)
    }

    public static func handleOnEditProfileViewAppear(){
        Task{
            await _M.setCurrentViewTitle("Edit Profiles")
            await _M.updateTextGroupEmps([])
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
            await _M.setProfileGroupCats(_C.PROFILE_GROUP_CATEGORIES)
        }
    }
    
    public static func handleDismiss(_ dismiss:DismissAction){
        Task{
            print("EditProfileViewProxy handleDismiss ...")
            await _M.setProfileGroupCats([])
            await _M.updateProfileGroupEmployees([])
            await _M.updateProfileStaffNotes([])
            await _M.updateLogs([])
            await _M.setProfile(Profile())
            dismiss()
        }
    }
}
