//
//  _C.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/6/23.
//
import Amplify
import SwiftUI

struct _C {
    /** App */
    static let OPT_STRING:String? = nil as String?
    static let OPT_ANYOBJECT:AnyObject? = nil as AnyObject?
    static let BUTTON_CANCEL:Int = 0
    static let BUTTON_SUBMIT:Int = 1
    static let HEADER_HEIGHT_PORTRAIT:CGFloat = 72.0
    static let HEADER_HEIGHT_LANDSCAPE:CGFloat = 100.0
    static let FOOTER_HEIGHT:CGFloat = 54.0
    
    /** Custom Views */
    static let BUTTON_EDGE_INSETS:EdgeInsets = EdgeInsets(top:8, leading:0, bottom:7, trailing:0)
    static let TEXT_FIELD_EDGE_INSETS:EdgeInsets = EdgeInsets(top:6, leading:18, bottom:7, trailing:10)
    static let TEXT_FIELD_PREFIX_EDGE_INSETS:EdgeInsets = EdgeInsets(top:5, leading:5, bottom:6, trailing:10)
    
    /** Error, Debug */
    static let PRINT_PREFIX:String = "############ -- MARCA -- $$$$$$$$$$$"
    static let PRINT_SUFFIX:String = "$$$$$$$$$$$ -- MARCA -- ############"
    
    static let MPTY_STR:String = ""
    static let MPTY_STRDICT:[String:String] = [_C.MPTY_STR:_C.MPTY_STR]
    static let MPTY_STRDICT_ARRAY:[[String:String]] = [_C.MPTY_STRDICT]
    
    /** MarcaClassFactory */
    static let ONLY_ONE_INSTANCE_ALLOWED:String = "NORMAL : this is a singleton class\(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let SINGLETON_EXISTS:String = "WARN : singleton already exists - access static instance instead \(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let ERROR_SINGLETON_FACTORY:String = "ERROR : singleton creation failed\(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let ERROR_CLASS_FACTORY:String = "ERROR : class creation failed\(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let WARN_MULTIPLE_INSTANCES_NOT_ALLOWED:String = "WARN : killing this instance : \(SINGLETON_EXISTS) : \(PRINT_PREFIX)\(PRINT_SUFFIX)"
    static let ERROR_FALSE_ISSINGLETON:String = "ERROR : Illegal operation - isSingleton is set to false : \(PRINT_PREFIX)\(PRINT_SUFFIX)"
    
    static let NORMAL_TYPE:Int = 0
    static let ERROR_TYPE:Int = 1
    static let MUST_OVERRIDE_INIT_TYPE:Int = 2
    static let STRICT_TYPE:Int = 3
    
    /** Cognito keychain */
    static let REMOTE_SERVER = "www.everphase.net"
    static let KEYCHAIN_ITEM_ADD:Int = 0
    static let KEYCHAIN_ITEM_UPDATE:Int = 1
    static let KEYCHAIN_ITEM_FIND:Int = 2
    static let KEYCHAIN_ITEM_MATCH_LIMIT:Int = 3
    
    static let KEYCHAIN_ITEM_NO_PERSIST:Int = 0
    static let KEYCHAIN_ITEM_PERSIST_NEW:Int = 1
    static let KEYCHAIN_ITEM_PERSIST_UPDATE:Int = 2
    
    /** Colors */
    static let deepBlueViolet:Color = Color(red: 77.0/255.0, green: 25.0/255.0, blue: 235.0/255.0, opacity: 1.0)
    static let blueVioletFuchsia:Color = Color(red: 225.0/255.0, green: 0.0/255.0, blue: 235.0/255.0, opacity: 0.8)
    static let marcaGray:Color = Color(red: 80.0/255.0, green: 50.0/255.0, blue: 130.0/255.0, opacity: 0.9)
    static let marcaDarkGray:Color = Color(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, opacity: 1.0)
    static let marcaLightGray:Color = Color(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, opacity: 0.2)
    static let marcaGreen:Color = Color(red: 40.0/255.0, green: 125.0/255.0, blue: 75.0/255.0, opacity: 1.0)
    static let marcaRed:Color = Color(red: 195.0/255.0, green: 75.0/255.0, blue: 40.0/255.0, opacity: 1.0)
    
    
    static let PROFILE_GROUP_CATEGORIES:[IdentifiableGroupCategories] = [
        IdentifiableGroupCategories(name:"A-B", range:"ab", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"C-D", range:"cd", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"E-F", range:"ef", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"G-H", range:"gh", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"I-J", range:"ij", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"K-L", range:"kl", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"M-N", range:"mn", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"O-P", range:"op", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"Q-R", range:"qr", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"S-T", range:"st", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"U-W", range:"uvw", title:"on_site_admin"),
        IdentifiableGroupCategories(name:"X-Z", range:"yz", title:"on_site_admin")
    ]
    
    static let TEXT_GROUP_CATEGORIES:[IdentifiableGroupCategories] = [
        IdentifiableGroupCategories(name:"Contacts-090822",title:"imp_temp", role:"g"),
        IdentifiableGroupCategories(name:"Contacts-092522",title:"imp2_temp", role:"g"),
        IdentifiableGroupCategories(name:"EPI-Admin",title:"on_site_admin", role:"S"),
        IdentifiableGroupCategories(name:"RES-Temps",title:"temp", role:"S")
    ]

}
