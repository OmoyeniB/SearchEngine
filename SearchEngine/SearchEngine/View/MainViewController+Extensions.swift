import UIKit
import WebKit

extension MainViewController {
    
    func configureView() {
        view.addSubview(stackView)
        stackView.addSubview(backButton)
        stackView.addSubview(nextButton)
        stackView.addSubview(searchField)
        view.addSubview(progressView)
        view.addSubview(scrollView)
        view.addSubview(contentView)
        contentView.addSubview(webKitView)
        
        configureStackView()
        configureProgressBar()
        configureBackButton()
        configureNextButton()
        configureSearchField()
        configureScrollView()
        configureWebKitView()
        configureContentView()
    }
    
    
    func configureStackView() {
        stackView.snp.makeConstraints({make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(view).inset(15)
            make.left.equalTo(view).offset(15)
            make.height.equalTo(50)
        })
    }
    
    func configureProgressBar() {
        
        progressView.isHidden = true
        progressView.snp.makeConstraints({ make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(5)
        })
    }
    func configureBackButton() {
        backButton.snp.makeConstraints({make in
            make.left.top.equalTo(stackView)
            make.width.equalTo(40)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureNextButton() {
        nextButton.snp.makeConstraints({make in
            make.right.top.equalTo(stackView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureSearchField() {
        searchField.snp.makeConstraints({make in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.center.equalTo(stackView.snp.center)
            make.top.equalTo(stackView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureScrollView() {
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(progressView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    func configureContentView() {
        contentView.snp.makeConstraints({ make in
            make.top.bottom.equalTo(scrollView)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.centerX.equalTo(scrollView)
            make.centerY.equalTo(scrollView)
        })
    }
    
    func configureWebKitView() {
        webKitView.snp.makeConstraints({ make in
            make.edges.equalTo(contentView)
        })
    }
    
}

extension MainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        backButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        searchField.text = webView.url?.absoluteString
        UIView.animate(withDuration: 0.33,
                       animations: {
            self.progressView.alpha = 0.0
        },
                       completion: { isFinished in
            self.progressView.isHidden = isFinished
        })
        
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.33,
                       animations: {
            self.progressView.alpha = 1.0
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        //        let urlString:String = Constants.url
        //        guard let url:URL = URL(string: urlString) else {return false}
        //        webKitView.load(URLRequest(url: url))
        
        let urlString: String = searchField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        
        webKitView.load(urlRequest)
        webKitView.allowsBackForwardNavigationGestures = true
        webKitView.allowsLinkPreview = true
        
        textField.resignFirstResponder()
        
        return true
    }
}

