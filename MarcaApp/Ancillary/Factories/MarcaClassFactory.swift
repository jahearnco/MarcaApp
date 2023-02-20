//
//  MarcaClassFactory.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/10/23.
//

import SwiftUI

struct MarcaClassFactory{

    public static func getInstance<T:MarcaClass>(className:String, kType:T.Type, instanceLabel:String=_C.MPTY_STR)->MarcaClass!{
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
                print("required init throwing MarcaError instanceLabel : \((si as! MarcaClass).getInstanceLabel())")
                throw MarcaError(message: _C.SINGLETON_EXISTS, methodName:#function, className:String(describing:type(of:instance)), instanceLabel:instanceLabel)
            }else{
                S.setStaticInstance(si:instance as? Singleton)
            }
        }
        
        if let i = instance{
            i.setInstanceLabel(il:instanceLabel)
        }else{
            print("handleNewInstance throwing MarcaError : NO INSTANCE EXISTS!!")
            throw MarcaError(message: _C.ERROR_CLASS_FACTORY, methodName:#function, className:"NONE", instanceLabel:instanceLabel)
        }
    }
}

protocol Marca{
    var instanceLabel:String { get set }
    init(instanceLabel:String) throws
    func getInstanceLabel()->String
}

class MarcaClass:Marca{
    var instanceLabel:String = _C.MPTY_STR
    public func getInstanceLabel()->String{ return instanceLabel }
    public func setInstanceLabel(il:String){ instanceLabel = il }
    required init(instanceLabel:String) throws{
        do{
            try MarcaClassFactory.handleNewInstance(instance:self, kType:type(of:self), instanceLabel:instanceLabel)
        }catch{
            print(error)
        }
    }
    deinit { print("DEINIT : Singleton instanceLabel:\(getInstanceLabel()) \(_C.WARN_MULTIPLE_INSTANCES_NOT_ALLOWED)") }
}

protocol Singleton{
    static func getStaticInstance()->Singleton?
    static func setStaticInstance(si:Singleton!)
}

protocol ObservableSingleton:ObservableObject,Singleton{}

