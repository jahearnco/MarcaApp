//
//  MarcaStructs.swift
//  MarcaApp
//
//  Created by Enjoy on 3/4/23.
//

import Amplify
import SwiftUI

struct MarcaLogItem:MarcaItem{
    var id:UUID = UUID()
    var itemId: String
    var auth: String?
    var desc: String?
    var descNote: String?
    var title: String?
    var createDateStr: String?
    var phone: String?
    var email: String?
}

struct Profile:MarcaItem{
    var id:UUID = UUID()
    var itemId: String
    var name:String = .emptyString
    var photoName:String = .emptyString
    var phone:String = .emptyString
    var email:String = .emptyString
    var salary:String = .emptyString
    var title:String = .emptyString
    var qrCode:String = .emptyString
    var currentStatus:String = MarcaProfileStatusChoice.notselected.rawValue
    var currentNote:String = .emptyString
    var staffNotes:[MarcaLogItem] = []
}

struct WorkgroupCategory:MarcaItem {
    var id:UUID = UUID()
    var itemId:String
    var range: String?// = .emptyString
    var title: String?// = .emptyString
    var role: String?// = .emptyString
    var phone: String?// = .emptyString
    
    
    static let profileWorkgroupCategories:[WorkgroupCategory] = [
        WorkgroupCategory(itemId:"A-B", range:"ab", title:"on_site_admin"),
        WorkgroupCategory(itemId:"C-D", range:"cd", title:"on_site_admin"),
        WorkgroupCategory(itemId:"E-F", range:"ef", title:"on_site_admin"),
        WorkgroupCategory(itemId:"G-H", range:"gh", title:"on_site_admin"),
        WorkgroupCategory(itemId:"I-J", range:"ij", title:"on_site_admin"),
        WorkgroupCategory(itemId:"K-L", range:"kl", title:"on_site_admin"),
        WorkgroupCategory(itemId:"M-N", range:"mn", title:"on_site_admin"),
        WorkgroupCategory(itemId:"O-P", range:"op", title:"on_site_admin"),
        WorkgroupCategory(itemId:"Q-R", range:"qr", title:"on_site_admin"),
        WorkgroupCategory(itemId:"S-T", range:"st", title:"on_site_admin"),
        WorkgroupCategory(itemId:"U-W", range:"uvw", title:"on_site_admin"),
        WorkgroupCategory(itemId:"X-Z", range:"yz", title:"on_site_admin")
    ]
    
    static let textingWorkgroupCategories:[WorkgroupCategory] = [
        WorkgroupCategory(itemId:"Contacts-090822",title:"imp_temp", role:"g"),
        WorkgroupCategory(itemId:"Contacts-092522",title:"imp2_temp", role:"g"),
        WorkgroupCategory(itemId:"EPI-Admin",title:"on_site_admin", role:"S"),
        WorkgroupCategory(itemId:"RES-Temps",title:"temp", role:"S")
    ]
}
