//
//  ViewController.swift
//  Project4
//
//  Created by paigu on 2020/04/05.
//  Copyright © 2020 paigu. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {
    var webView:WKWebView!
    var progressview:UIProgressView!
    var websites = ["apple.com","hackingwithswift.com"]
    
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressview = UIProgressView(progressViewStyle: .default)
        progressview.sizeToFit()
        let profressButton = UIBarButtonItem(customView: progressview)
        
        toolbarItems = [profressButton,spacer,refresh]
        navigationController?.isToolbarHidden = false
        //観察者追加
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://\(websites[0])/")!
        webView.load(URLRequest(url: url))
        // スワイプで履歴を戻る/進む有効化
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page ...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //ipad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true, completion: nil)
    }
    
    func openPage(action:UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressview.progress = Float(webView.estimatedProgress)
        }
    }
    //遷移する前にチェク
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}

