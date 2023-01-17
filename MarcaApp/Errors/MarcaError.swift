//
//  MarcaError.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/8/23.
//

import SwiftUI

struct MarcaError: Error {
    let message: String
    let methodName: String
    let className:String
    let instanceLabel:String
}
