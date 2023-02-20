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
            .onAppear(perform: { ContentViewParentProxy.handleOnContentViewParentAppear(geometrySize: g.size) })
            .onChange(of: g.size, perform: { _ in
                ContentViewParentProxy.handleOnContentViewParentChange(geometrySize: g.size)
            })
        }
    }
}

struct ContentViewParent_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewParent()
    }
}

struct ContentViewParentProxy{
    
    public static func handleOnContentViewParentAppear(geometrySize: CGSize){
        Task{
            handleOnContentViewParentChange(geometrySize: geometrySize)
            
            #if DEBUG
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            #endif
            
            await UIApplication.shared.addTapGestureRecognizer()
            
            await _M.updateTextGroupEmps([])
            await _M.updateCellPhoneDict(_C.MPTY_STRDICT)
        }
    }
    
    public static func handleOnContentViewParentChange(geometrySize: CGSize){
        Task{
            print("handleOnContentViewParentAppear fullWidth : \(geometrySize.width) ")
            print("handleOnContentViewParentAppear fullHeight : \(geometrySize.height) ")
            
            await _M.setAppFullWidth(geometrySize.width)
            await _M.setAppFullHeight(geometrySize.height)
            await _M.setAppFullScreenAspectRatio(geometrySize.width/geometrySize.height)
            await _M.setIsPortraitOrientation(geometrySize.width/geometrySize.height < 1)
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = firstScene.windows.first else { return }
        
        let tapGesture = UITapGestureRecognizer(target: firstWindow, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        firstWindow.addGestureRecognizer(tapGesture)
    }
}

 extension UIApplication: UIGestureRecognizerDelegate {
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true // set to `false` if you don't want to detect tap during other gestures
     }
 }
