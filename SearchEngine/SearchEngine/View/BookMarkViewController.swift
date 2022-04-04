import UIKit

class BookMarkViewController: UIViewController {
    
    var didCompleteBookmark: CoordinatorTransition?
    var arrayOfBookmarks = UserDefaults.standard.array(forKey: "allbookmarks") as? [String] ?? []
    var linkToMainViewController: MainViewController?
    var bookmarks: [String] = []
    let bookMarkCell = BookmarkTableCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Bookmarks"
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let isControllerAlreadyLoaded = UserDefaults.standard.bool(forKey: "viewLoaded")
    }
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkTableCell.self, forCellReuseIdentifier: BookmarkTableCell.identifier)
        return tableView
    }()
    
    func configureView() {
        saveBookMarkCreated()
        configureTableView()
        createTabBar()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
    }
    
    func saveBookMarkCreated() {
        bookmarks = UserDefaults.standard.object(forKey: "bookmark") as? [String] ?? []
    }
    
    func deleteBookmarkFromList() {
        UserDefaults.standard.set(arrayOfBookmarks, forKey: "allbookmarks")
    }
    
    func createTabBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancleButtonTapped))
        toolbarItems = [cancelButton]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func cancleButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


extension BookMarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableCell.identifier) as? BookmarkTableCell
        cell?.bookmarkLink.text = arrayOfBookmarks[indexPath.row]
    
        
//        cell?.bookmarkLink.text = bookmarks[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print ("cell tapped")
       
        let vc = ViewBookMarkedItem()
        var text = vc.text.text
        text = arrayOfBookmarks[indexPath.row]
        guard let url = URL(string: text ?? "") else {return}
        vc.webView.load(URLRequest(url: url))
        vc.webView.load(URLRequest(url: url)) 
     
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.arrayOfBookmarks.remove(at: indexPath.row)
            self.deleteBookmarkFromList()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

extension BookMarkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfBookmarks.count
    }
}
