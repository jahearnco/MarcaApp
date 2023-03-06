//
//  MarcaProtocols.swift
//  MarcaApp
//
//  Created by Enjoy on 3/4/23.
//

import Amplify
import SwiftUI

protocol MarcaItem:Identifiable,Equatable{
    var id:UUID { get set }
    var itemId:String { get set }
}

protocol MarcaViewProxy{
    static func handleOnViewAppear(_ model:_M?, geometrySize: CGSize?, items:any MarcaItem...)->Void
    static func handleOnViewDisappear()->Void
}

protocol Marca{
    var instanceLabel:String { get set }
    init(instanceLabel:String) throws
    func getInstanceLabel()->String
}

protocol Singleton{
    static func getStaticInstance()->Singleton?
    static func setStaticInstance(si:Singleton!)
}

protocol ObservableSingleton:ObservableObject,Singleton{}
