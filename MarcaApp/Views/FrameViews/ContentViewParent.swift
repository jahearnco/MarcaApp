//
//  ContentViewParent.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/15/22.
//
//
//  ContentView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/8/22.
//

import SwiftUI
import Combine

struct ContentViewParent: View {
    var body: some View {
        GeometryReader{ g in
            VStack(alignment:.center, spacing:0){
                ContentView()
            }
            .border(Color.red, width:_D.flt(0))
            .onAppear(perform: { ContentViewParentProxy.handleOnViewAppear(geometrySize: g.size) })
            .onChange(of: g.size, perform: {
                ContentViewParentProxy.handleOnContentViewParentChange(geometrySize: $0 as CGSize)
            })
        }
    }
}

struct ContentViewParent_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewParent()
    }
}

struct ContentViewParentProxy:MarcaViewProxy{
    static func handleOnViewDisappear() {
        //TBD
    }
     
    public static func handleOnViewAppear(_ model:_M?=nil, geometrySize:CGSize?=nil, items:any MarcaItem...){
        Task{
            print("ContentViewParent onAppear")
            
            if let geometrySize = geometrySize{
                handleOnContentViewParentChange(geometrySize: geometrySize)
            }
            
            #if DEBUG
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            #endif
            
            await UIApplication.shared.addTapGestureRecognizer()
        }
    }
    
    public static func handleOnContentViewParentChange(geometrySize: CGSize){
        Task{
            _D.dPrint("handleOnContentViewParentAppear fullWidth : \(geometrySize.width) ")
            _D.dPrint("handleOnContentViewParentAppear fullHeight : \(geometrySize.height) ")
            
            await _M.setAppFullWidth(geometrySize.width)
            await _M.setAppFullHeight(geometrySize.height)
            await _M.setAppFullScreenAspectRatio(geometrySize.width/geometrySize.height)
            await _M.setIsPortraitOrientation(geometrySize.width/geometrySize.height < 1)
        }
    }
}
