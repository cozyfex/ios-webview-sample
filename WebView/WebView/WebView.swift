//
//  WebView.swift
//  WebView
//
//  Created by CozyFex on 2022/11/02.
//

import UIKit
import SwiftUI
import Combine
import WebKit

protocol WebViewHandlerDelegate {
    func showToast(value: String)
}

struct WebView: UIViewRepresentable, WebViewHandlerDelegate {

    var url: String
    @ObservedObject var viewModel: WebViewModel
    @State var webView = WKWebView()

    func showToast(value: String) {
        print(value)
        webView.evaluateJavaScript("document.querySelector('input').value = 'iOS'") { (result, error) in
            if error == nil {
                print(result as Any)
            }
        }
    }

    func receivedJsonValueFromWebView(value: [String: Any?]) {
        print("JSON 데이터가 웹으로부터 옴: \(value)")
    }

    func receivedStringValueFromWebView(value: String) {
        print("String 데이터가 웹으로부터 옴: \(value)")
    }

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let pagePreferences = WKWebpagePreferences()
        pagePreferences.allowsContentJavaScript = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.defaultWebpagePreferences = pagePreferences
        configuration.userContentController.add(makeCoordinator(), name: "AppJS")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        if let url = URL(string: self.url) {
            webView.load(URLRequest(url: url))
        }

        // For local html
        //        if let indexURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html") {
        //            print(indexURL)
        //            webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
        //        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("updateUIView")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var delegate: WebViewHandlerDelegate?

        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            self.delegate = parent
        }

        deinit {
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            /*
             if let host = navigationAction.request.url?.host {
             // 특정 도메인을 제외한 도메인을 연결하지 못하게 할 수 있다.
             if host != "cozyfex.com" {
             return decisionHandler(.cancel)
             }
             }
             */

            return decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("기본 프레임에서 탐색이 시작되었음")
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("내용을 수신하기 시작")
        }

        func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
            // @State webView에 로딩된 페이지 세팅
            parent.webView = webView
            print("탐색이 완료")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            print("초기 탐색 프로세스 중에 오류가 발생했음")
            print(withError)
        }
    }
}

extension WebView.Coordinator: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name == "AppJS" {
            let data = message.body as! [String: Any?]

            switch data["name"] as! String {
            case "showToast":
                delegate?.showToast(value: data["value"] as! String)
            default:
                print("default")
            }
        }
    }
}
