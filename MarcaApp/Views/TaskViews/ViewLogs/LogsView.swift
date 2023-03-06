//
//  LogsView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//
import Amplify
import SwiftUI

struct LogsView: View {
    //@Environment(\.dismiss) var dismiss
    @StateObject var model:_M = _M.M()
    @Binding var logs:[MarcaLogItem]
    
    var bgColor:Color = .marcaLightGray
    var bodyHeight:CGFloat = 120
    var outerMarginWidth:CGFloat = 16
    
    var body: some View {
        VStack(alignment:.center, spacing:0){
            List {
                ForEach (logs) { logItem in
                    MarcaLogView(logItem:logItem, bgColor:bgColor, bodyHeight:bodyHeight, outerMarginWidth:outerMarginWidth)
                }
                .onDelete { indexSet in
                    logs.remove(atOffsets: indexSet)
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
        .onAppear(perform:handleOnViewAppear)
    }
    
    func handleOnViewAppear(){
        print("LogsView handleOnViewAppear BEGIN")
        logs = []
        print("LogsView handleOnViewAppear END")
    }
}

struct CommunityLogsView: View {
    @StateObject var model:_M = _M.M()
    
    var body: some View {
        ZStack{
            LogsView(logs:$model.communityLogs)
                .padding(.bottom, 1)
                .onAppear(perform: { CommunityLogsViewProxy.handleOnViewAppear(model) } )

            ProgressView("Loading ...")
                .opacity(model.communityLogs.count == 0 ? 1 : 0)
        }
    }
}

struct CommunityLogsViewProxy:MarcaViewProxy{
    public static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...) {
        Task{
            print("await _M.updateCommunityLogs([]) BEGIN")
            await _M.updateCommunityLogs([])
            print("await getCommunityLogs(model?.user) BEGIN")
            let logItems = await getCommunityLogs(model?.user)
            print("await getCommunityLogs(model?.user) END")
            await _M.updateCommunityLogs(logItems)
            print("await _M.updateCommunityLogs(model.communityLogs) END")
        }
    }

    public static func handleOnViewDisappear(){

    }
    
    public static func formatTitleDate(dateStr:String)->String{
        return dateStr
    }
    
    public static func getCommunityLogs(_ user:User?) async -> [MarcaLogItem]{
        guard let user = user else {
            print("cannot get logs - user is nil")
            return []
        }
        
        var logItems:[MarcaLogItem] = []
        
        print("getCommunityLogs() making RESTRequest ... ")

        let body = [
            "employeeWorkGroups": user.userWorkgroups,
            "roleId" : user.userRole,
            "timeStr" : user.logviewTimeframe,
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
                                        let logItem = MarcaLogItem(itemId:"item\(logItems.count)", auth:authStr!, desc:descStr!, title:titleStr ?? .emptyString, createDateStr:dateStr!)
                                        logItems.append(logItem)
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
        return logItems
    }
}
