//
//  _D.swift
//  MarcaApp
//
//  Created by Enjoy on 2/3/23.
//

import SwiftUI

struct _D{
    static var debug:Bool = false
    
    static func flt(_ flt:CGFloat)->CGFloat{
        return debug ? flt : 0.0
    }
}
