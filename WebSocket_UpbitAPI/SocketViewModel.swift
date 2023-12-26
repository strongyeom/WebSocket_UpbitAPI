//
//  SocketViewModel.swift
//  WebSocket_UpbitAPI
//
//  Created by 염성필 on 2023/12/26.
//

import Foundation
import Combine

class SocketViewModel: ObservableObject {
    
    @Published var askOrderBook: [OrderbookItem] = []
    
    @Published var bidOrderBook: [OrderbookItem] = []
    
    private var cancelable = Set<AnyCancellable>() // dispose
    
    init() {
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send()
        
        // 받아온 데이터 -> 가공
        // RxSwift Subscribe == Combine sink 완전히 똑같은 것은 아님
        // RxSwift schedular == Combine receive
        WebSocketManager.shared.orderBookSbj
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self else { return }
                self.askOrderBook = order.orderbookUnits
                    .map { OrderbookItem(price: $0.askPrice, size: $0.askSize)}
                    .sorted { $0.price > $1.price }
                self.bidOrderBook = order.orderbookUnits
                    .map { OrderbookItem(price: $0.bidPrice, size: $0.bidSize)}
                    .sorted { $0.price > $1.price }
            }
            .store(in: &cancelable)
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
    
}
