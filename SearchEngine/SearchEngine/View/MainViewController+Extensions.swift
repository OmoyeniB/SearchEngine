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
        stackView.addSubview(nextButton)
        stackView.addSubview(searchBar)
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
    
    func modelsToModifyView() {
        didPullToRefresh()
        setupEstimatedProgressObserver()
        configureSearchbarController()
        createToolBarItems()
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
        searchBar.snp.makeConstraints({make in
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
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
       print("click")
    }
}

