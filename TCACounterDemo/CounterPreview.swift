//
//  CounterPreview.swift
//  TCACounterDemo
//
//  Created by Anypli M1 Air on 28/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct CounterPreview: View {
    var body: some View {
        CounterView(
            store: TCACounterDemoApp.store
        )
    }
}

#Preview {
    CounterPreview()
}
