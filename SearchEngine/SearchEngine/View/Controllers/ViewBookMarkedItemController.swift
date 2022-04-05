import UIKit
import WebKit

class ViewBookMarkedItem: UIViewController {
    
    lazy var progressView = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createToolBarItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.activityIndicator.stopAnimating()
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        var contentView = UIView()
        return contentView
    }()
    
    lazy var webView: WKWebView = {
        let preference = WKWebpagePreferences()
        let configuration = WKWebViewConfiguration()
        preference.allowsContentJavaScript = true
        var webView = WKWebView(frame: .zero, configuration: configuration)
        configuration.defaultWebpagePreferences = preference
        webView.navigationDelegate = self
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        return webView
    }()
    
    lazy var text: UILabel = {
        var text = UILabel()
        text.tintColor = .red
        return text
    }()
    
    func configureView() {
        configureProgressBar()
        configureScrollView()
        configureContentView()
        configureWebView()
        didPullToRefresh()
        setupEstimatedProgressObserver()
    }
    
    func didPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
    }
    
    func refreshDidStop(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            sender.endRefreshing()
        })
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        self.refreshDidStop(sender)
    }
    
    func configureProgressBar() {
        view.addSubview(progressView)
        progressView.isHidden = true
        progressView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(5)
        })
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(progressView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    func configureContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.top.bottom.equalTo(scrollView)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.centerX.equalTo(scrollView)
            make.centerY.equalTo(scrollView)
        })
    }
    
    func configureWebView() {
        contentView.addSubview(webView)
        webView.snp.makeConstraints({make in
            make.edges.equalTo(contentView)
        })
    }
    
    func createToolBarItem() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clickedToRefresh))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [spacer, refreshButton]
        navigationController?.isToolbarHidden = false
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
