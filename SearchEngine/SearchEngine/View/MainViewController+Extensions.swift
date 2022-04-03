import UIKit
import WebKit

extension MainViewController {
    
    func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(progressView)
        view.addSubview(scrollView)
        view.addSubview(contentView)
        stackView.addSubview(backButton)
        stackView.addSubview(containerView)
        containerView.addSubview(nextButton)
        containerView.addSubview(bookMark)
        stackView.addSubview(searchBar)
        contentView.addSubview(webKitView)
        webKitView.addSubview(imageStackView)
        
        configureStackView()
        configureProgressBar()
        configureBackButton()
        configureSearchField()
        configureContainerView()
        configureNextButton()
        configureBookMark()
        configureScrollView()
        configureWebKitView()
        configureImageStackView()
        configureContentView()
        
    }
    
    func modelsToModifyView() {
        didPullToRefresh()
        setupEstimatedProgressObserver()
        configureSearchbarController()
        createToolBarItems()
    }
    
    
    func configureStackView() {
        stackView.snp.makeConstraints({make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(view).inset(10)
            make.left.equalTo(view).offset(10)
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
    
    func configureContainerView() {
        containerView.snp.makeConstraints({make in
            make.top.equalTo(stackView)
            make.left.equalTo(searchBar.snp.right).offset(20)
            make.right.equalTo(stackView).inset(10)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureBookMark() {
        bookMark.snp.makeConstraints({ make in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView)
            make.height.equalTo(stackView.snp.height)
//            make.width.equalTo(stackView.snp.height)
        })
    }
    
    func configureNextButton() {
        nextButton.snp.makeConstraints({make in
            make.top.equalTo(containerView)
            make.left.equalTo(bookMark.snp.right).offset(5)
            make.right.equalTo(containerView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureSearchField() {
        searchBar.snp.makeConstraints({make in
            make.left.equalTo(backButton.snp.right).offset(5)
            make.top.equalTo(stackView)
            make.height.equalTo(stackView.snp.height)
            make.center.equalTo(stackView.snp.center).offset(-30)
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
    
    func configureImageStackView() {
        imageStackView.snp.makeConstraints({make in
            make.centerY.equalTo(webKitView).offset(-200)
            make.centerX.equalTo(webKitView)
        })
    }
    
}

extension MainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        backButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        searchBar.text = webView.url?.absoluteString
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
        displayError(error: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.targetFrame == nil {
                if let url = navigationAction.request.url {
                    let app = UIApplication.shared
                    if app.canOpenURL(url) {
                        app.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            decisionHandler(.allow)
        }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.replacingOccurrences(of: " ", with: ""), !text.isEmpty else {
            return
        }
        
        let baseString = Constants.SearchString.baseString
        var url = Constants.SearchString.baseUrl
        let searchQuery = Constants.SearchString.searchQuery
        let dotcom = Constants.SearchString.dotCom
//        let dotorg = Constants.SearchString.dotOrg
//        let dotnet = Constants.SearchString.dotNet
        if text.contains(baseString) {
            url = text
        } else if
            (!text.contains(baseString) && text.contains(dotcom)) {
            url = baseString + text
        } else if
            (!text.contains(baseString) && !text.contains(dotcom)) {
            url = searchQuery+text
        }
        self.fetchDataFromWebkit(urlString: url)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            //cancel button becomes disabled when search bar isn't first responder, force it back enabled
            DispatchQueue.main.async {
                if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                    cancelButton.isEnabled = true
                }
            }
            return true
        }

//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//            self.present(UINavigationController(rootViewController: SearchViewController()), animated: false, completion: nil)
//        }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
       print("link has been added to bookMark successfully")
        
    }
    
   
}

