//
//  TCACounterDemoTests.swift
//  TCACounterDemoTests
//
//  Created by Anypli M1 Air on 28/11/2023.
//

import XCTest
import ComposableArchitecture
@testable import TCACounterDemo

@MainActor
final class TCACounterDemoTests: XCTestCase {
    
    //    var store: TestStore<CounterFeature.State, CounterFeature.Action>!
    //
    //    override func setUp() async throws {
    //        store = TestStore(initialState: CounterFeature.State()) {
    //            CounterFeature()
    //        }
    //    }
    
    func test_counter() async throws {
        let store = TestStore(initialState: CounterFeature.State()) { /// Should be declared in the function's scope to throw side affects fails
            CounterFeature()
        }
        
        await store.send(.increaseButtonTapped) {
            $0.count = 1
        }
        await store.send(.decreaseButtonTapped) {
            $0.count = 0
        }
    }
    
    func test_timer() async throws {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 2
        }
        // ✅ Test Suite 'Selected tests' passed at 2023-08-04 11:17:44.823.
        //        Executed 1 test, with 0 failures (0 unexpected) in 1.044 (1.046) seconds
        //    or:
        // ❌ Expected to receive an action, but received none after 0.1 seconds.
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    func test_number_fact() async throws {
        let store = TestStore(initialState: CounterFeature.State()) { /// Should be declared in the function's scope to throw side affects fails
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number"}
        }
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number"
        }
    }
}
