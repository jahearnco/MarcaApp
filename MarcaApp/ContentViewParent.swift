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

struct ContentViewParent: View {

    var body: some View {
        ContentView()
            .onAppear(perform: { Task{ await FlowController.handleOnContentViewAppear() } } )
    }
}

struct ContentViewParent_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewParent()
    }
}

