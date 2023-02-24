//
//  MarcaEnums.swift
//  MarcaApp
//
//  Created by Enjoy on 2/19/23.
//
import Amplify
import SwiftUI

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(_ status: OSStatus)
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

extension CaseIterable where Self: RawRepresentable {
    static var allValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}
