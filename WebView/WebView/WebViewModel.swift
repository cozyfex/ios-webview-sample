//
//  WebViewModel.swift
//  WebView
//
//  Created by CozyFex on 2022/11/02.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
    var me: String = ""
    var foo = PassthroughSubject<String, Never>()
    var bar = PassthroughSubject<String, Never>()
}
