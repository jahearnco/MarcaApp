//
//  CheckboxFieldView.swift
//  MarcaApplified
//
//  Created by Enjoy on 12/23/22.
//

import SwiftUI

struct CheckboxFieldView: View {
    @State var checkState: Bool = false
    @Binding var cellNums:[String:String]?
    
    var empName:String?
    var phone:String?
    
    var body: some View {
        Button(action:
        {
            self.checkState = !self.checkState
            print("State : \(self.checkState)")
            
            if let p = phone{
                if let e = empName{

                    if var _ = self.cellNums{
                        print("numList self.cellNums exists")
                    }else{
                        print("numList initializing self.cellNums")
                        self.cellNums = [String:String]()
                    }
                    self.cellNums?[e] = self.checkState ? p : nil
                }
            }
        })
        {
            HStack(alignment: .top, spacing: 10) {
                Rectangle()
                    .fill(self.checkState ? Color.green : Color.red)
                    .frame(width:15, height:15, alignment: .center)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top:2, leading:0, bottom:0, trailing:0))
                    .onAppear( perform:
                    {
                        if let name = empName {
                            if let _ = self.cellNums{
                                if let cNums = self.cellNums{
                                    self.checkState = cNums[name] != nil
                                }
                            }

                        }
                    })

                if let name = empName {
                    Text(name)
                        .font(.custom("helvetica", size:13))
                        .padding(EdgeInsets(top:0, leading:0, bottom:2, trailing:0))
                }
            }
        }
        .foregroundColor(Color.black)
    }
    
}
