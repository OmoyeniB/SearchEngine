import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {
    
    lazy var urlRequest:URLRequest = URLRequest(url: URL(string: "")!)
    lazy var progressView = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureView()
        didPullToRefresh()
        setupEstimatedProgressObserver()
        
        let backB = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: webKitView, action: nil)
        let share = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webKitView, action: #selector(presentShareSheet))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(webKitView.reload))
        
        toolbarItems = [backB, share, spacer, refresher]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func presentShareSheet() {
        let url = urlRequest
        
        let shareSheet = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: nil)
        present(shareSheet, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        let urlString:String = "https://www.youtube.com/"
        let url:URL = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
        
        webKitView.load(urlRequest)
        searchField.text = urlString
    }
    
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)
        
        progressView.isHidden = true
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webKitView.observe(\.estimatedProgress, options: [.new]) { [weak self] webKitView, _ in
            self?.progressView.progress = Float(webKitView.estimatedProgress)
        }
    }
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.isEnabled = false
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return backButton
    }()
    
    
    lazy var nextButton: UIButton = {
        var nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonCliked), for: .touchUpInside)
        return nextButton
    }()
    
    lazy var searchField: UITextField = {
        var searchField = UITextField()
        searchField.placeholder = "Type here to search..."
        searchField.isUserInteractionEnabled = true
        searchField.layer.borderColor = UIColor.lightGray.cgColor
        searchField.layer.borderWidth = 0.5
        searchField.delegate = self
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.layer.cornerRadius = 10
        searchField.textAlignment = .center
        return searchField
    }()
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        return activityIndicator
    }()
    
    lazy var contentView: UIView = {
        var contentView = UIView()
        return contentView
    }()
    
    lazy var webKitView: WKWebView = {
        var webKitView = WKWebView()
        webKitView.addSubview(activityIndicator)
        webKitView.allowsBackForwardNavigationGestures = true
        webKitView.allowsLinkPreview = true
        webKitView.navigationDelegate = self
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        return webKitView
    }()
    
    @objc func backButtonClicked() {
        if webKitView.canGoBack {
            webKitView.goBack()
        }
    }
    
    @objc func nextButtonCliked() {
        if webKitView.canGoForward {
            webKitView.goForward()
        }
    }
    
    func didPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webKitView.scrollView.addSubview(refreshControl)
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        self.webKitView.reload()
        self.refreshDidStop(sender)
    }
    
    func refreshDidStop(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            sender.endRefreshing()
        })
    }
}

