//
//  Constants.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/6/23.
//


enum ConstantsEnum {
    static let PRINT_PREFIX:String = "############ -- MARCA -- $$$$$$$$$$$"
    static let PRINT_SUFFIX:String = "$$$$$$$$$$$ -- MARCA -- ############"
    
    static let MPTY_STRDICT_ARRAY:[[String:String]] = [["":""]]
    
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
}
