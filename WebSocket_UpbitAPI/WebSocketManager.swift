//
//  WebSocketManager.swift
//  WebSocket_UpbitAPI
//
//  Created by 염성필 on 2023/12/26.
//

import Foundation
import Combine

// 요청하고 응답하는 것을 관리하기 위한 파일
final class WebSocketManager: NSObject {
    static let shared = WebSocketManager()
    
    private override init() { // override 붙이는 이유 : NSObject를 상속 받고 있기 때문에 채택해야함
        super.init() // 상위에 있는 데이터도 활용할것이기 때문에 super 사용
    }
    
    private var timer: Timer?  // 5초, 10초에 한번 살아있다고 알려줘야 하기때문에 Timer 필요

    
    private var webSocket: URLSessionWebSocketTask?
    
    // 플래그를 통해 소켓 연결 상태 확인
    private var isOpen = false
    
    // RxSwfit PublishSubject  == Combine PassthroughSubject
    // RxSwift BehaviorSubject  == Combine CurrentValueSubject
    // RxSwift 데이터 타임만 설정 vs Combine 데이터 타입 + 오류 타입 함께 지정
    var orderBookSbj = PassthroughSubject<OrderBookWS, Never>()
    
    
    func openWebSocket() {
        
        // dataTask는 JSON형식으로 한번에 데이터를 줌
        
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            webSocket = session.webSocketTask(with: url)
            
            webSocket?.resume()
            
            ping()
        }
    }
    
    
    // 필요하지 않을때는 통로 닫아주기
    func closeWebSocket() {
        
        // URLSessionWebSocket Enum Close Code
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        
        timer?.invalidate()
        timer = nil
        
        // 소켓 연결에 대한 연결을 안정적으로 해제하기 위해 close에도 설정
        isOpen = false
    }
    
    // 소켓 연결 이후 send 메서드를 통해 원하는 데이터를 받기 위해 요청함
    func send() {
        let string = """
        [{"ticket":"test"},{"type":"orderbook","codes":["KRW-BTC"]}]
        """
        webSocket?.send(.string(string), completionHandler: { error in
            if let error {
                print("send error, \(error)")
            }
        })
    }
    
    func receive() {
        
        if isOpen {
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
                    // print("recevie success, \(success)")
                    switch success {
                    case .data(let data):
                        
                        if let decodedData = try? JSONDecoder().decode(OrderBookWS.self, from: data) {
                            print("receive \(decodedData)")
                            
                            // onNext == send
                            self?.orderBookSbj.send(decodedData)
                        }
                        
                    case .string(let string): print(string)
                        
                    @unknown default: print("unknown Error")
                    }
                case .failure(let failure):
                    print("recevie failure, \(failure)")
                    self?.closeWebSocket()
                }
                // receive 될때 통신이 한번만 되는 문제를 재귀적으로 receive를 다시 해서 구성 <- WWDC 공식 방법
                self?.receive()
            })
        }
    }
    
    // 서버에 의해 연결이 끊어지지 않도록 주기적으로 ping을 서버에 보냄
    private func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("Ping Pong Error")
                } else {
                    print("Ping Success")
                }
            })
        })
    }
    
}

extension WebSocketManager: URLSessionWebSocketDelegate { // URLSessionWebSocketDelegate은 최종적으로 NSObject Protocol을 채택받고 있기 때문에 WebSocketManager에 NSObject를 상속 받아야함
    
    // didOpen : 웹 소켓 연결이 되어있는지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket Open")
        isOpen = true
        // 웹 소켓 연결 된 이후에 응답을 받아야함
        receive()
    }
    
    // didClose : 웹소켓이 해제되었는지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isOpen = false
        print("WebSocket Close")
    }
    
}
