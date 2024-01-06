//
//  SocketView.swift
//  WebSocket_UpbitAPI
//
//  Created by 염성필 on 2023/12/26.
//

import SwiftUI

struct SocketView: View {
    
    @StateObject var viewModel = SocketViewModel()
    

    var body: some View {
        ScrollView {
           
                ForEach(viewModel.askOrderBook, id: \.id) { item in
                    LazyVStack(alignment: .leading) {
                        Text("매도 잔량 : \(item.size)")
                        convert(item.price)
                    }
                    .padding()
                   
                }
            
        }
     
    }
    
    
    func convert(_ number: Double) -> some View {
        var convertDoubleToString = number.formatted(.number)
        return Text("매도 호가 : \(convertDoubleToString)원")
    }
}

struct SocketView_Previews: PreviewProvider {
    static var previews: some View {
        SocketView()
    }
}
