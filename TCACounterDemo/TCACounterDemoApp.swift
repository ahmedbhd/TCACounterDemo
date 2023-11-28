//
//  TCACounterDemoApp.swift
//  TCACounterDemo
//
//  Created by Anypli M1 Air on 28/11/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCACounterDemoApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCACounterDemoApp.store)
        }
    }
}
