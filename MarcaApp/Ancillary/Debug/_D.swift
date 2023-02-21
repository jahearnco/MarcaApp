//
//  _D.swift
//  MarcaApp
//
//  Created by Enjoy on 2/3/23.
//

import SwiftUI

struct _D{
    static var fltDebug:Bool = false
    static var printDebug:Bool = false
    
    static func flt(_ flt:CGFloat)->CGFloat{
        return fltDebug ? flt : 0.0
    }
    
    static func print(_ str:String){
        if printDebug { print(str) }
    }
}
