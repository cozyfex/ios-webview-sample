//
//  ContentView.swift
//  WebView
//
//  Created by CozyFex on 2022/11/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WebViewModel()
    
    var body: some View {
        VStack {
            WebView(url: "http://127.0.0.1:3000", viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
