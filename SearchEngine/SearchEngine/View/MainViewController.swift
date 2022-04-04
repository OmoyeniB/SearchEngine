import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    lazy var progressView = UIProgressView(progressViewStyle: .default)
   
    var savedBookmarks: [String] = []
    var listAllBoookmarks = UserDefaults.standard.array(forKey: "allbookmarks") as? [String] ?? []
    let searchBar = UISearchBar()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        modelsToModifyView()
        print(listAllBoookmarks.count, "BookMarks listed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.activityIndicator.stopAnimating()
    }
    
  public func convertTextInSerachFiledToUrl() {
       
        guard let text = searchBar.text?.replacingOccurrences(of: " ", with: ""), !text.isEmpty else {
            return
        }
        
        let baseString = Constants.SearchString.baseString
        var url = Constants.SearchString.baseUrl
        let searchQuery = Constants.SearchString.searchQuery
        let dotcom = Constants.SearchString.dotCom
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
        
        var urlRequest = URLRequest(url: URL(string: url)!)
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
    
    func createToolBarItems() {
        
        let bookMarkButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openBookMarkedItem))
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clickedToRefresh))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleButtonTapped))
        
        toolbarItems = [bookMarkButton, spacerButton, refreshButton, spacerButton, cancelButton]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func cancleButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openBookMarkedItem() {
        let bookmark = BookMarkViewController()
        let navigationController = UINavigationController(rootViewController: bookmark)
        self.present(navigationController, animated: true, completion: nil)
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
        estimatedProgressObserver = webKitView.observe(\.estimatedProgress, options: [.new]) { [weak self] webKitView, _ in
            self?.progressView.progress = Float(webKitView.estimatedProgress)
        }
    }
    
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
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.isEnabled = true
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
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonCliked), for: .touchUpInside)
        return nextButton
    }()
    
    @objc func clickToAddToBookmark() {
        
        guard let text = searchBar.searchTextField.text else {return}
        if !listAllBoookmarks.contains(text) {
            listAllBoookmarks.append(text)
        }
        UserDefaults.standard.set(listAllBoookmarks, forKey: "allbookmarks")
        
        
//        if let text = searchBar.searchTextField.text {
//            if !savedBookmarks.contains(text) && text.count > 0{
//                savedBookmarks.append(text)
//            }
//        }
//        UserDefaults.standard.set(savedBookmarks, forKey: "bookmark")
//
    }
    
    func configureSearchbarController() {
        searchBar.sizeToFit()
        searchBar.clipsToBounds = true
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = Constants.MainViewStrings.searchBarplaceholder
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.isTranslucent = true
    }
    
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
    
    @objc func clickedToRefresh() {
       convertTextInSerachFiledToUrl()
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
    
    func fetchDataFromWebkit(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        webKitView.load(URLRequest(url: url))
    }
    
    
}
