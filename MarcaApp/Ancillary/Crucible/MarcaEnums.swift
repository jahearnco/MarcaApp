//
//  MarcaEnums.swift
//  MarcaApp
//
//  Created by Enjoy on 2/19/23.
//
import Amplify
import SwiftUI

enum MarcaError: Error {
    case invalidCollectionsOperation(message:String, method:String)
    case invalidInstance(message:String, method:String, instanceLabel:String)
    case keychainNoPassword(message:String, method:String)
    case keychainUnexpectedPassword(message:String, method:String)
    case keychainUnhandledError(message:String, method:String, status: OSStatus)
    
    /** MarcaClassFactory */
    /** Error, Debug */
    static let PRINT_PREFIX:String = "############ -- MARCA -- $$$$$$$$$$$"
    static let PRINT_SUFFIX:String = "$$$$$$$$$$$ -- MARCA -- ############"
    static let SINGLETON_EXISTS:String = "WARN : singleton already exists - access static instance instead \(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let ERROR_CLASS_FACTORY:String = "ERROR : class creation failed\(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let WARN_MULTIPLE_INSTANCES_NOT_ALLOWED:String = "WARN : killing this instance : \(SINGLETON_EXISTS) : \(PRINT_PREFIX)\(PRINT_SUFFIX)"
}

enum MarcaProfileTitle:String,CaseIterable{
    case temp = "Temp"
    case fTemp = "FTemp"
    case op = "Operator"
    case on_site_not = "Conductor"
    case on_site_admin = "OS Admin"
    case on_site_support = "OS Supp"
    case on_site_supervisor = "OS Supe"
    case on_site_manager = "OS Mgr"
    case floor_manager = "Floor Mgr"
    case director = "Director"
    case project_engineer = "Proj Eng"
    case manager = "Manager"
    case software_engineer = "Software Eng"
}

enum MarcaViewChoice{
    case noView
    case loginView
    case logoutChoiceView
    case taskView
    case textCreateView
    case editProfileView
    case logsView
}

enum MarcaTitle{
    case viewTitle(currentView:MarcaViewChoice)
    case profileTitle
    
    static func getTitle(from: MarcaTitle)->String{
        var retStr = "MARCA"
        switch from {
        case .viewTitle(let currentView):
            switch currentView{
            case .textCreateView:
                retStr = "Create Text"
            case .logsView:
                retStr = "View Logs"
            case .editProfileView:
                retStr = "Edit Profiles"
            default:
                retStr = "MARCA"
            }
        case .profileTitle:
            retStr = "profileTitle"
        }
        return retStr
    }
}

enum MarcaLoginMenuChoice:String,CaseIterable{
    case about = "About MARCA"
    case preferences = "Preferences"
}

enum MarcaCreateTextMenuChoice:String,CaseIterable{
    case titles = "Title"
    case dept = "Department"
    case workgroups = "Workgroups"
}

enum MarcaEditProfilesMenuChoice:String,CaseIterable{
    case titles = "Title"
    case dept = "Department"
    case workgroups = "Workgroups"
}

enum MarcaProfileStatusChoice:String,CaseIterable{
    case dnr = "Do Not Return"
    case excellent = "Excellent"
    case good = "Good"
    case poor = "Poor"
    case late = "Late"
    case sick = "Out Sick"
    case unprocessed = "Unprocessed"
    case notselected = "Status"
}

enum MarcaLogsViewMenuChoice:String,CaseIterable{
    case dateRange = "Date Range"
    case workgroups = "Workgroups"
    case topic = "Topic"
    case severity = "Severity"
}


enum MarcaSelectType:String,CaseIterable {
    
    case loginMenuChoices //MarcaLoginMenuChoice
    case logsViewMenuChoices //MarcaLogsViewMenuChoice
    case createTextMenuChoices //MarcaLogsViewMenuChoice
    case editProfilesMenuChoices //MarcaEditProfilesMenuChoice
    case profileStatusChoices //MarcaProfileStatusChoice

    public static func getStrArr(_ msType:MarcaSelectType)->[String]{
        var rvArr:[RawValue]
        switch msType{
            
        case .loginMenuChoices:
            rvArr = MarcaLoginMenuChoice.allValues
            
        case .logsViewMenuChoices:
            rvArr = MarcaLogsViewMenuChoice.allValues
            
        case .createTextMenuChoices:
            rvArr = MarcaCreateTextMenuChoice.allValues
            
        case .editProfilesMenuChoices:
            rvArr = MarcaEditProfilesMenuChoice.allValues
            
        case .profileStatusChoices:
            rvArr = MarcaProfileStatusChoice.allValues
        }
        return rvArr as [String]
    }
}

enum MarcaItemHashManager {
    
    enum Action:Int{
        case replaceAll = 9
        case add = 1
        case remove = -1
        case removeAll = -9
    }

    public static func toArray<T>(_ iHash:[String:any MarcaItem]?, kType:T.Type)->[T]{
        var retArr:[T] = []
        if let h = iHash{
            var index = 0
            for (_,v) in h{
                if let v = v as? T{
                    retArr[index] = v
                    index += 1
                }
            }
        }
        return retArr
    }
    
    public static func add(_ iHash:[String:any MarcaItem], _ item:any MarcaItem)throws->[String:any MarcaItem]{
        if try MarcaItemHashManager.exists(iHash, item.itemId){
            throw MarcaError.invalidCollectionsOperation(message:"duplicate : \(item.itemId)", method:#function)
        }else{
            var h = iHash
            h[item.itemId] = item
            return h
        }
    }
    
    public static func remove(_ itemHash:[String:any MarcaItem], _ item:any MarcaItem)throws->[String:any MarcaItem]{
        if !(try MarcaItemHashManager.exists(itemHash, item.itemId)){
            throw MarcaError.invalidCollectionsOperation(message:"attempt operate on nil : \(item.itemId)", method:#function)
        }else{
            var h = itemHash
            h.removeValue(forKey:item.itemId)
            return h
        }
    }
    
    public static func exists(_ itemHash:[String:any MarcaItem], _ key:String?)throws->Bool{
        if let key = key{
            return itemHash[key] != nil
        }else{
            throw MarcaError.invalidCollectionsOperation(message:"key is invalid : \(String(describing:key))", method:#function)
        }
    }
    
    public static func removeAll(_ itemHash:[String:any MarcaItem])->[String:any MarcaItem]{
        var h = itemHash
        h.removeAll()
        return h
    }
    
    public static func update(itemHash:[String:any MarcaItem]?, item:(any MarcaItem)?=nil, action:Action)->[String:any MarcaItem]{
        var retHash = [String:any MarcaItem]()
        do {
            if let itemHash = itemHash, let item = item{
                switch action {
                case .replaceAll:
                    retHash = itemHash
                case .add:
                    retHash = try MarcaItemHashManager.add(itemHash, item)
                case .remove:
                    retHash = try MarcaItemHashManager.remove(itemHash, item)
                case .removeAll:
                    retHash = MarcaItemHashManager.removeAll(itemHash)
                }
            }
        }catch{
            print(error)
        }
        return retHash
    }
}
