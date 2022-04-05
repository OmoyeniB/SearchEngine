import WebKit
import UIKit

extension MainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        searchBar.text = webView.url?.absoluteString
        let grayColor = UIColor.systemGray
        let blueColor = UIColor.systemBlue
        if  backButton.isEnabled == webView.canGoBack {
            backButton.setTitleColor(blueColor, for: .normal)
        } else {
            backButton.setTitleColor(grayColor, for: .normal)
            backButton.isEnabled = true
        }
        
        if nextButton.isEnabled == webView.canGoForward {
            nextButton.setTitleColor(blueColor, for: .normal)
        } else {
            nextButton.setTitleColor(grayColor, for: .normal)
            nextButton.isEnabled = true
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        
        if topBookMarkButton.isHighlighted == true {
            topBookMarkButton.tintColor = .blue
        }
        else {
            topBookMarkButton.tintColor = .systemGray
        }
        
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
        } else {
            progressView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.33,
                       animations: {
            self.progressView.alpha = 1.0
        })
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.isToolbarHidden = false
        displayImage.isHidden = true
        displayText.isHidden = true
        convertTextInSerachFiledToUrl()
    }
    
}
