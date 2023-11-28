//
//  CounterFeature.swift
//  TCACounterDemo
//
//  Created by Anypli M1 Air on 28/11/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
@Reducer
struct CounterFeature {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case decreaseButtonTapped
        case increaseButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decreaseButtonTapped:
                state.count -= 1
                return .none
            case .increaseButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}

// MARK: - View
struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        viewStore.send(.decreaseButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    
                    Button("+") {
                        viewStore.send(.increaseButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}
