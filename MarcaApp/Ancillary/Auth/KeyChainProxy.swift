//
//  KeyChainProxy.swift
//  MarcaApp
//
//  Created by Enjoy on 2/20/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import SwiftUI

struct KeychainProxy{
    
    public static func updateKeychainPassword(creds:Credentials) throws -> (OSStatus, AnyObject?){
        let attribsToUpdate = [kSecValueData: creds.password!.data(using: .utf8)!] as CFDictionary
        let query = getKechainItemQuery(creds:creds, type:_C.KEYCHAIN_ITEM_UPDATE)
        return (SecItemUpdate(query, attribsToUpdate), _C.OPT_ANYOBJECT)
    }
    
    public static func saveKeychainPassword(creds:Credentials) throws -> (OSStatus, AnyObject?){
        var result: AnyObject?
        let query = getKechainItemQuery(creds:creds, type:_C.KEYCHAIN_ITEM_ADD)
        return (SecItemAdd(query, &result), result)
    }

    public static func loadKeychainPassword(creds:Credentials)->String?{
        do{
            let itemDict = try findKeychainItemDict(creds:creds)
            if let array = itemDict.1 as? [NSDictionary]{
                for dic in array {
                    if let pw = String(data: dic[kSecValueData] as! Data, encoding: .utf8){
                        return pw
                    }
                }
            }
        }catch{
            print("ERROR KeychainProxy::loadKeychainPassword \(error)")
        }
        return _C.OPT_STRING
    }
    
    private static func findKeychainItemDict(creds:Credentials) throws -> (OSStatus, AnyObject?){
        let query = getKechainItemQuery(creds:creds, type:_C.KEYCHAIN_ITEM_FIND)
        var result: AnyObject?
        return (SecItemCopyMatching(query, &result), result)
    }
    
    public static func deleteKeychainItems(){
        let svrArr:[String] = [ "!net.everphase.www", "net.everphase.www", "www.everphase.net", "https://www.everphase.net", "http://www.everphase.net"]
        for svr in svrArr{
            let query = [
                kSecClass: kSecClassInternetPassword,
                kSecAttrServer: svr,
                kSecAttrAccount: "John@everphase.net"
            ] as CFDictionary
            
            print("svr:\(svr) \(SecItemDelete(query))")
        }
    }
    
    private static func getKechainItemQuery(creds:Credentials, type:Int)->CFDictionary{
        var retQuery:[CFString: Any] = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: _C.REMOTE_SERVER
        ]
        
        if let un = creds.username{
            retQuery[kSecAttrAccount] = un.lowercased()

            //add
            if type == _C.KEYCHAIN_ITEM_ADD, let pw = creds.password, pw.count > 0{
                retQuery[kSecValueData] = pw.data(using: String.Encoding.utf8)!
            }
            
            //find
            if type == _C.KEYCHAIN_ITEM_FIND{
                retQuery[kSecMatchLimit] = _C.KEYCHAIN_ITEM_MATCH_LIMIT
            }
            
            //item update query does not take these dict keys,vals
            if type != _C.KEYCHAIN_ITEM_UPDATE{
                retQuery[kSecReturnAttributes] = true
                retQuery[kSecReturnData] = true
            }
        }
        return retQuery as CFDictionary
    }
}
