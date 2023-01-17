//
//  FlowController.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/17/22.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import SwiftUI
/*
 static methods for flow control
 */
struct FlowController{
    static private var dataModel:DataModel = DataModel.DM()
    static private var appDelegate:AppDelegate!
    
    public static func setAppDelegate(appDele:AppDelegate){
        appDelegate = appDele
    }

    public static func appDele() -> AppDelegate!{
        return appDelegate
    }
    
    public static func doLogout()async{
        let logoutSuccess = await Cognito.authSignOut()
        if (logoutSuccess){
            var authLoginName:String!
            if let user = dataModel.user{
                authLoginName = user.authLoginName
            }else{
                authLoginName = "UNEXPECTED: NO USERNAME!"
            }
            print("\(authLoginName!) has signed out successfully")
        }else{
            print("UNEXPECTED: LOGOUT UNSUCCESSFUL!")
        }
    }
    
    /** LoginViewFlow */
    public static func handleIfUserLoggedIn(loggedInUser:AuthUser?)async{
        let isLoggedIn = loggedInUser != nil
        await DataModel.setIsUserLoggedIn(loggedIn:isLoggedIn, isMainThread:false)//updates on main thread asap
        if isLoggedIn {
            await previewLogsUpdateView(isMainThread:true)//updates on main thread asap - change view before Logs update
        }

        let user:User = await Cognito.getUser(loggedInUser:loggedInUser)
        await DataModel.setLoggedInUsername(loggedInUsername:user.userFirstNameLastI, isMainThread:false)//updates on main thread asap
        await DataModel.setUser(user:user, isMainThread:false)//updates on main thread asap
        
        if isLoggedIn {
            await getLogs(user:user)//loading in background
        }
    }
    
    public static func getLoggedInUser()async->AuthUser?{
        return await Cognito.getAuthUser()
    }
    
    public static func handleLoginButtonAction(autoLogin:Bool)async->Bool{
        let loggedIn = await Cognito.doLogin(autoLogin:autoLogin, u:"", p:"")
        
        if loggedIn{
            let loggedInUser:AuthUser? = await getLoggedInUser()
            await handleIfUserLoggedIn(loggedInUser:loggedInUser)
        }else{
            //LoginView to deal with failure
            //do we nullify user here and update accordingly?
            //should save/persist user first of course
            await handleIfUserLoggedIn(loggedInUser:nil)
        }
        return loggedIn
    }
    
    public static func handleLogoutButtonAction()async->Bool{
        let logoutSuccess = await Cognito.authSignOut()
        await DataModel.setIsUserLoggedIn(loggedIn:!logoutSuccess, isMainThread:false)
        return logoutSuccess
    }
    
    public static func handleTextCreated(success:Bool) async{
        if(success){
            await previewLogsUpdateView(isMainThread: false) //change view before Logs update
            await getLogs(user:dataModel.user)
        }
    }
    
    public static func submitTextForSend(title:String, body:String, cellInfo:String) async -> Bool{
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
            "workLogAuthor":dataModel.user?.fullName ?? "",
            "workLogDesc":body,
            "workLogCellInfo":cellInfo,
            "workLogLastDesc":"",
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
        var catArr: [[String: String]] = []
        print("making RESTRequest for texting group categories ... ")
        
        //https://gely35v1j1.execute-api.us-west-2.amazonaws.com/prod/employees?cat=TimeStation&value=S&dept=all&title=on_site_admin

        let request = RESTRequest(path:"/employees", queryParameters: ["cat":"TimeStation", "value":role, "dept":"all", "title":title])
        
        do {
            let data = try await Amplify.API.get(request: request)
            
            if let textCatDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            {

                if let textCats = textCatDict["employees"] as? NSArray {
                    
                    print("textCats.count = \(textCats.count)")

                    for tCat:Any in textCats {
                        var contactInfo:String?
                        var phone:String?
                        var empName:String?
                        if let tCatD = tCat as? NSDictionary{
                            for (key,val) in tCatD{
                                if let keyStr = key as? NSString{
                                    if (keyStr == "contactInfo"){
                                        if let val = val as? String {
                                            contactInfo = val
                                            if let contactInfoArr = contactInfo?.components(separatedBy: "^~`"){
                                                if (contactInfoArr.count > 0){
                                                    phone = contactInfoArr[0] as String
                                                }
                                            }
                                        }
                                    }else if (keyStr == "name"){
                                        if let val = val as? String {
                                            empName = val
                                        }
                                    }
                                    
                                    if (phone != nil && empName != nil){
                                        let empContactDict:[String:String] = ["name": empName! ,"phone":phone!]
                                        catArr.append(empContactDict)
                                        break
                                    }
                                }
                            }
                        }
                    }
                     
                }
            }
            print("getTextingCatEmps calling handleTextGroupEmpsUpdated ...")
            await handleTextGroupEmpsUpdated(emps:catArr)
            //return catArr

        }catch{
            print(error)
        }
        //return catArr
    }
    
    private static func previewLogsUpdateView(isMainThread:Bool)async{
        await DataModel.setShowLogListTask(showLogListTask:true, isMainThread:isMainThread)
        await DataModel.setShowTextCreateTask(showTextCreateTask:false, isMainThread:isMainThread)
    }
    
    public static func showTextCreateTask(isMainThread:Bool)async{
        await DataModel.setShowLogListTask(showLogListTask:false, isMainThread:isMainThread)
        await DataModel.setShowTextCreateTask(showTextCreateTask:true, isMainThread:isMainThread)
    }
    
    public static func handleTextGroupEmpsUpdated(emps : [[String:String]])async{
        await showTextCreateTask(isMainThread:false)
        await DataModel.updateTextGroupEmps(textGroupEmployees:emps, isMainThread:false)
    }
    
    public static func getLogs(user:User?) async {
        var usr:User!
        if let _ = user{
            usr = user
        }else{
            print("cannot get logs - user is nil")
            return
        }
        
        var descArr: [[String: String]] = []
        print("making RESTRequest ... ")

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
                                    }
                                    
                                    if (authStr != nil && descStr != nil){
                                        let sureTitle:String! = titleStr ?? ""
                                        let descDict:[String:String] = ["auth": authStr!,"desc":descStr!,"title":sureTitle]
                                        descArr.append(descDict)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            await DataModel.updateLogData(logs:descArr, isMainThread:false)

        }catch{
            print(error)
        }
        //return descArr
    }
    
    public static func handleGetLogsButtonAction()async{
        await previewLogsUpdateView(isMainThread:false)
        await getLogs(user:dataModel.user)
    }
    
    public static func handleOnContentViewParentAppear()async{
        await DataModel.updateLogData(logs: ConstantsEnum.MPTY_STRDICT_ARRAY, isMainThread:false)
    }
    
    public static func handleOnContentViewAppear()async{
        await DataModel.updateLogData(logs: ConstantsEnum.MPTY_STRDICT_ARRAY, isMainThread:false)
    }

    public static func handleOnLoginViewAppear()async{
        await DataModel.updateLogData(logs: ConstantsEnum.MPTY_STRDICT_ARRAY, isMainThread:false)
    }
    
    public static func handleOnTextCreateViewAppear()async{
        await DataModel.updateLogData(logs: ConstantsEnum.MPTY_STRDICT_ARRAY, isMainThread:false)
    }
    
    public static func handleOnTaskViewAppear(){
    }
 
    public static func handleOnLogsViewAppear(){
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
