//
//  DataModel.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/8/23.
//

import SwiftUI

struct PublishedResult{
    var complete:Bool = false
}
/**
 view state and data model
 @Published vars and static public functions
 static class behavior: singleton instance and static public methods
 required init disallows attempt to create multiple instances during compilation
 */
final class DataModel:MarcaClass,ObservableSingleton {
    /**begin:Requirements to adhere to Singleton Protocol*/
    private static var _inst:Singleton?
    static func getStaticInstance() -> Singleton? { return _inst as? Self }
    static func setStaticInstance(si: Singleton!) { _inst = si as! Self }
    /**end:Requirements to adhere to Singleton Protocol*/

    public static func DM()->DataModel!{
        if let _ = _inst{
            return _inst as? DataModel
        }else{
            return nil
        }
    }

    @Published var loggedIn:Bool = false
    @MainActor
    public static func setIsUserLoggedIn(loggedIn:Bool){
        DM().loggedIn = loggedIn
    }
     
    @Published var loggedInUsername:String?
    @MainActor
    public static func setLoggedInUsername(loggedInUsername:String?){
        DM().loggedInUsername = loggedInUsername
    }
     
    @Published var user:User?
    @MainActor
    public static func setUser(user:User?){
        DM().user = user
    }
    
    @Published var logs:[[String:String]] = [["":""]]
    @MainActor
    public static func updateLogData(logs:[[String:String]]){
        DM().logs = logs
    }

    @Published var cellPhoneDict:[String:String]?
    @MainActor
    public static func updateCellPhoneList(cellPhoneDict:[String:String]?){
        DM().cellPhoneDict = cellPhoneDict
    }

    @Published var textGroupEmployees:[[String:String]] = [["":""]]
    @MainActor
    public static func updateTextGroupEmps(textGroupEmployees:[[String:String]]){
        DM().textGroupEmployees = textGroupEmployees
    }
    
    @Published var dismissCatViewLinks:Bool = false
    public static func setDismissCatViewLinks(dismissCatViewLinks:Bool){
        DM().dismissCatViewLinks = dismissCatViewLinks
    }

    @Published var showLogListTask:Bool = false
    @MainActor
    public static func setShowLogListTask(showLogListTask:Bool){
        DM().showLogListTask = showLogListTask
    }

    @Published var showTextCreateTask:Bool = false
    @MainActor
    public static func setShowTextCreateTask(showTextCreateTask:Bool){
        DM().showTextCreateTask = showTextCreateTask
    }

    @Published var textGroupCats:[[String:String]] = [
        ["name":"Contacts-090822","title":"imp_temp", "role":"g"],
        ["name":"Contacts-092522","title":"imp2_temp", "role":"g"],
        ["name":"EPI-Admin","title":"on_site_admin", "role":"S"],
        ["name":"RES-Temps","title":"temp", "role":"S"]
    ] //var even though constant for now to be modifiable later - if @Published must not be a constant
}
