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
        var fact: String?
        var isLoading = false
    }
    
    enum Action {
        case decreaseButtonTapped
        case increaseButtonTapped
        case factResponse(String)
        case factButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decreaseButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .increaseButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    let (data, _ ) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    
                    await send(.factResponse(fact))
                }
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
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
                
                Button("Fact") {
                    viewStore.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}
