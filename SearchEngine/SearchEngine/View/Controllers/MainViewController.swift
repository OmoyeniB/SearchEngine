import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {
    
    var url = Constants.SearchString.baseUrl
    private var estimatedProgressObserver: NSKeyValueObservation?
    lazy var progressView = UIProgressView(progressViewStyle: .default)
    var listAllBoookmarks = UserDefaults.standard.array(forKey: "allbookmarks") as? [String] ?? []
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        modelsToModifyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.activityIndicator.stopAnimating()
    }
    
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.clipsToBounds = true
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = Constants.ViewStrings.searchBarplaceholder
        searchBar.delegate = self
        searchBar.isTranslucent = true
        return searchBar
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.gray, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return backButton
    }()
    
    lazy var containerView: UIView = {
        var containerView = UIView()
        return containerView
    }()
    
    lazy var bookMark: UIButton = {
        var bookMark = UIButton()
        bookMark.setImage(Constants.Images.bookMark, for: .normal)
        bookMark.addTarget(self, action: #selector(clickToAddToBookmark), for: .touchUpInside)
        return bookMark
    }()
    
    lazy var nextButton: UIButton = {
        var nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.systemGray, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonCliked), for: .touchUpInside)
        return nextButton
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
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    lazy var contentView: UIView = {
        var contentView = UIView()
        return contentView
    }()
    
    lazy var webKitView: WKWebView = {
        let preference = WKWebpagePreferences()
        var webKitView = WKWebView()
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.defaultWebpagePreferences = preference
        webKitView.addSubview(activityIndicator)
        webKitView.allowsBackForwardNavigationGestures = true
        webKitView.allowsLinkPreview = true
        webKitView.navigationDelegate = self
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        return webKitView
    }()
    
    func passTextAsUrlToWebKit(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        webKitView.load(URLRequest(url: url))
    }
    
    public func convertTextInSerachFiledToUrl() {
        
        var isWebPage: Bool = false
        guard let text = searchBar.text?.replacingOccurrences(of: " ", with: ""), !text.isEmpty else {
            return
        }
        let baseArrays = Constants.SearchString.arrayOfbase
        let baseString = Constants.SearchString.baseString
        let searchQuery = Constants.SearchString.searchQuery
        let dotcom = Constants.SearchString.dotCom
        
        for item in baseArrays {
            if text.contains(item) {
                isWebPage = true
                break
            }
        }
        
        if text.contains(baseString) {
            url = text
        } else if
            (!text.contains(baseString) && isWebPage) {
            
            if text.first != "." {
                url = baseString + text
            } else {
                url = searchQuery+text
            }
            
        } else if
            (!text.contains(baseString) && !text.contains(dotcom)) {
            url = searchQuery+text
        }
        
        passTextAsUrlToWebKit(urlString: url)
        fetchDataFromWebKit()
    }
    
    func fetchDataFromWebKit() {
        guard let url = URL(string: url) else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.displayError(error: error?.localizedDescription ?? error.debugDescription)
                    self.progressView.isHidden = true
                }
                return
            }
            
            guard let content = data else {
                self.progressView.isHidden = true
                return
            }
            
            guard ((try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]) != nil else {
                return
            }
        }
        task.resume()
    }
    
    func createToolBarItems() {
        let bookMarkButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openBookMarkedItem))
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clickedToRefresh))
        
        toolbarItems = [bookMarkButton, spacerButton, refreshButton]
        navigationController?.isToolbarHidden = true
    }
    
    @objc func openBookMarkedItem() {
        let bookmark = BookMarkViewController()
        self.navigationController?.pushViewController(bookmark, animated: true)
    }
    
    @objc func clickedToRefresh() {
        convertTextInSerachFiledToUrl()
    }
    
    func swipeView() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftHandleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action:#selector(rightHandleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func leftHandleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            webKitView.goForward()
        }
    }
    
    @objc func rightHandleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            webKitView.goBack()
        }
    }
    
    func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webKitView.observe(\.estimatedProgress, options: [.new]) { [weak self] webKitView, _ in
            self?.progressView.progress = Float(webKitView.estimatedProgress)
        }
    }
    
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
    
    @objc func clickToAddToBookmark() {
        guard let text = searchBar.searchTextField.text else { return }
        if !listAllBoookmarks.contains(text) && text.count > 0 && text.contains("https://") && text.contains(".") {
            listAllBoookmarks.append(text)
        }
        UserDefaults.standard.set(listAllBoookmarks, forKey: "allbookmarks")
    }
    
    func didPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webKitView.scrollView.addSubview(refreshControl)
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        convertTextInSerachFiledToUrl()
        self.refreshDidStop(sender)
    }
    
    func refreshDidStop(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            sender.endRefreshing()
        })
    }
    
}
