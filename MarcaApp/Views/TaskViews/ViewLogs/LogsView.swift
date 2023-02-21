//
//  LogsView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//
import Amplify
import SwiftUI

struct LogsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()

    var bgColor:Color = _C.marcaLightGray
    var bodyHeight:CGFloat = 86
    var outerMarginWidth:CGFloat = 16
    
    var body: some View {
        VStack(alignment:.center, spacing:0){
            List {
                ForEach(model.logs, id: \.self) { logDict in
                    MarcaLogView(logDict:logDict, bgColor:bgColor, bodyHeight:bodyHeight, outerMarginWidth:outerMarginWidth)
                }
            }
            .listStyle(.inset)
            .padding(.top, outerMarginWidth)
            .border(Color.red, width:_D.flt(1))
            .background(bgColor)
        }
        .padding(0)
        .opacity(model.menuDoesAppear ? 0.2 : 1)
        .border(Color.green, width:_D.flt(1))
        .onAppear(perform: {
            _D.print("LogsView onAppear logList:\(String(describing:model.logs))")
        } )
        .onChange(of:model.logs, perform: { list in
            _D.print("LogsView onChange logList:\(String(describing: list))")
        } )
    }
}

struct CommunityLogsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()

    var body: some View {
        ZStack{
            LogsView().padding(.bottom, 1)

            ProgressView("Loading ...")
                .opacity(model.logs.count == 0 ? 1 : 0)
        }
        .onAppear(perform: {
            LogsViewProxy.handleOnCommunityLogsViewAppear();
            _D.print("CommunityLogsView onAppear logList:\(String(describing: model.logs))")
        } )
        .onChange(of:model.logs, perform: { list in
            _D.print("CommunityLogsView onChange logList:\(String(describing: list))")
        } )
        .onChange(of:model.taskViewChoice, perform:{ tvc in
            if tvc != .logsView {
                LogsViewProxy.handleDismiss(dismiss)
            }
        })
    }
}

struct LogsViewProxy{
    static var model:_M = _M.M()
    
    public static func handleDismiss(_ dismiss:DismissAction){
        Task{
            await _M.updateLogs([])
            dismiss()
        }
    }
    
    public static func formatTitleDate(dateStr:String)->String{
        return dateStr
    }
    
    public static func getLogs() async {
        await _M.updateCommunityLogs([])
        await _M.updateLogs([])
        
        var usr:User!
        if let _ = model.user{
            usr = model.user
        }else{
            print("cannot get logs - user is nil")
            return
        }
        
        var descArr: [[String: String]] = []
        
        print("getLogs() making RESTRequest ... ")

        let body = [
            "employeeWorkGroups": usr.userWorkgroups,
            "roleId" : usr.userRole,
            "timeStr" : usr.logviewTimeframe,
            "typeVal":"All",
            "topicVal":"All"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        let request = RESTRequest(
            path:"/workLogs",
            body: jsonData
        )

        do {
            let data = try await Amplify.API.post(request: request)
            
            if let wlogDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {
                if let wLogs = wlogDict["workLogs"] as? NSArray {
                    
                    print("wLogs.count = \(wLogs.count)")
                    
                    for wLog:Any in wLogs {
                        var descStr:String?
                        var authStr:String?
                        var titleStr:String?
                        var dateStr:String?
                        if let wLogD = wLog as? NSDictionary{
                            for (key,val) in wLogD{
                                if let keyStr = key as? NSString{
                                    if (keyStr == "title"){
                                        if let val = val as? String {
                                            titleStr = val
                                        }
                                    }else if (keyStr == "description"){
                                        if let val = val as? String {
                                            descStr = val
                                        }
                                    }else if (keyStr == "author"){
                                        if let val = val as? String {
                                            authStr = val
                                        }
                                    }else if (keyStr == "workLogCreateDateStr"){
                                        if let val = val as? String {
                                            dateStr = val
                                        }
                                    }
                                    
                                    if (authStr != nil && descStr != nil){
                                        let sureTitle:String! = titleStr ?? _C.MPTY_STR
                                        let descDict:[String:String] = ["auth": authStr!,"desc":descStr!,"title":sureTitle,"logDateStr":dateStr!]
                                        descArr.append(descDict)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            await _M.updateCommunityLogs(descArr)
            await _M.updateLogs(model.communityLogs)

        }catch{
            print(error)
        }
        //return descArr
    }

    public static func handleOnCommunityLogsViewAppear(){
        Task{
            await _M.setCurrentViewTitle("View Logs")
            await _M.updateTextGroupEmps([])
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
        }
    }
}
