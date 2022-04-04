import UIKit
import WebKit

class ViewBookMarkedItem: UIViewController {
    
    lazy var progressView = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObserver: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        configureView()
    }
    
    func configureView() {
        view.addSubview(webView)
        webView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
        createToolBarItem()
        setupProgressView()
        setupEstimatedProgressObserver()
    }
    
    
    lazy var webView: WKWebView = {
        let preference = WKWebpagePreferences()
        let configuration = WKWebViewConfiguration()
        preference.allowsContentJavaScript = true
        var webView = WKWebView(frame: .zero, configuration: configuration)
        configuration.defaultWebpagePreferences = preference
       return webView
    }()
     
    lazy var text: UILabel = {
        var text = UILabel()
        text.tintColor = .red
       return text
    }()
    
    func createToolBarItem() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clickedToRefresh))
        
        toolbarItems = [refreshButton]
        navigationController?.isToolbarHidden = false
    }
    
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        progressView.isHidden = true
        navigationBar.addSubview(progressView)
        progressView.snp.makeConstraints{ make in
            make.bottom.left.right.equalTo(navigationBar)
            make.height.equalTo(2.0)
        }
    }
    
    func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func clickedToRefresh() {
        webView.reload()
    }
    
}
