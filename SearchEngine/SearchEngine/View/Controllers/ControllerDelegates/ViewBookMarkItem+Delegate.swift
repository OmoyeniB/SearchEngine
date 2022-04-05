import UIKit
import WebKit

extension ViewBookMarkedItem: WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}
