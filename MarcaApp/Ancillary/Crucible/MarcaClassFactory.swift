//
//  MarcaClassFactory.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/10/23.
//

import SwiftUI

enum MarcaClassFactory{

    public static func getInstance<T:MarcaClass>(className:String, kType:T.Type, instanceLabel:String = .emptyString)->MarcaClass!{
        var maybeNewInstance:MarcaClass?
        let Klass = NSClassFromString("MarcaApp.\(className)") as? T.Type
        do{
            if let K = Klass {
                if let S = K as? Singleton.Type, let si = S.getStaticInstance(){
                    maybeNewInstance = si as? T
                    print("MCF instance of Singleton already exists : \(maybeNewInstance!.getInstanceLabel())")
                }else{
                    maybeNewInstance = try K.init(instanceLabel:instanceLabel)
                    print("MCF creating new Singleton : \(instanceLabel)")
                }
            }
        }
        catch let error as MarcaError{ print("MARCA : \(error)") }
        catch{ print("SWIFT : \(error)") }
        
        print("MCF returning instance for \(maybeNewInstance!.getInstanceLabel())");
        return maybeNewInstance
    }
    
    public static func handleNewInstance<T:MarcaClass>(instance:MarcaClass?, kType:T.Type, instanceLabel:String)throws {
        if let S = kType as? Singleton.Type{
            if let si = S.getStaticInstance(){
                _D.dPrint("required init throwing MarcaError instanceLabel : \((si as! MarcaClass).getInstanceLabel())")
                throw MarcaError.invalidInstance(message: MarcaError.SINGLETON_EXISTS, method:#function, instanceLabel:instanceLabel)
            }else{
                S.setStaticInstance(si:instance as? Singleton)
            }
        }
        
        if let i = instance{
            i.setInstanceLabel(il:instanceLabel)
        }else{
            _D.dPrint("handleNewInstance throwing MarcaError : NO INSTANCE EXISTS!!")
            throw MarcaError.invalidInstance(message: MarcaError.ERROR_CLASS_FACTORY, method:#function, instanceLabel:instanceLabel)
        }
    }
}

class MarcaClass:Marca{
    var instanceLabel:String = .emptyString
    public func getInstanceLabel()->String{ return instanceLabel }
    public func setInstanceLabel(il:String){ instanceLabel = il }
    required init(instanceLabel:String) throws{
        do{
            try MarcaClassFactory.handleNewInstance(instance:self, kType:type(of:self), instanceLabel:instanceLabel)
        }catch{
            print(error)
        }
    }
    deinit { print("DEINIT : Singleton instanceLabel:\(getInstanceLabel()) \(MarcaError.WARN_MULTIPLE_INSTANCES_NOT_ALLOWED)") }
}

