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
        VStack {
            ForEach(viewModel.askOrderBook, id: \.id) { item in
                Text("\(item.price)")
            }
        }
    }
}

struct SocketView_Previews: PreviewProvider {
    static var previews: some View {
        SocketView()
    }
}
