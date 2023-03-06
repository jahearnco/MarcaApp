//
//  MarcaExtensions.swift
//  MarcaApp
//
//  Created by Enjoy on 3/4/23.
//

import Amplify
import SwiftUI

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

extension AnyObject? {
    static var optAnyObject:AnyObject? { return nil as AnyObject? }
}

extension String {
    static var emptyString:String { return "" }
    static var optString:String? { return nil as String? }

    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

extension CaseIterable where Self: RawRepresentable {
    static var allValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}

extension Color {
    static var deepBlueViolet:Color { return Color(red: 77.0/255.0, green: 25.0/255.0, blue: 235.0/255.0, opacity: 1.0) }
    static var blueVioletFuchsia:Color { return Color(red: 225.0/255.0, green: 0.0/255.0, blue: 235.0/255.0, opacity: 0.8) }
    static var marcaGray:Color { return Color(red: 80.0/255.0, green: 50.0/255.0, blue: 130.0/255.0, opacity: 0.9) }
    static var marcaDarkGray:Color { return Color(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, opacity: 1.0) }
    static var marcaLightGray:Color { return Color(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, opacity: 0.2) }
    static var marcaGreen:Color { return Color(red: 40.0/255.0, green: 125.0/255.0, blue: 75.0/255.0, opacity: 1.0) }
    static var marcaRed:Color { return Color(red: 195.0/255.0, green: 75.0/255.0, blue: 40.0/255.0, opacity: 1.0) }
}

extension MarcaLogItem {
    static var emptyMarcaLogItem:MarcaLogItem { return MarcaLogItem(itemId:.emptyString) }
}

extension Profile {
    static var emptyProfile:Profile { return Profile(itemId:.emptyString) }
}

extension Int {
    static var buttonCancel:Int { return 0 }
    static var buttonSubmit:Int { return 1 }
}

extension CGFloat {
    static var headerHeightPortrait:CGFloat { return 72.0 }
    static var headerHeightLandscape:CGFloat { return 100.0 }
    static var footerHeight:CGFloat { return 54.0 }
}

extension EdgeInsets {
    static var buttonEdgeInsets:EdgeInsets { return EdgeInsets(top:8, leading:0, bottom:7, trailing:0) }
    static var textFieldEdgeInsets:EdgeInsets { return EdgeInsets(top:6, leading:18, bottom:7, trailing:10) }
    static var textFieldPrefixEdgeInsets:EdgeInsets { return EdgeInsets(top:5, leading:5, bottom:6, trailing:10) }
}
