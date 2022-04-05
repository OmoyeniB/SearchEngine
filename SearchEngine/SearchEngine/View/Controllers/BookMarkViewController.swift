import UIKit

class BookMarkViewController: UIViewController {
    
    var viewItemsThatHasBeenBookMarked: ViewBookMarkedItem?
    var navigateToBookmarkItem: ((URLRequest) -> Void)?
    var arrayOfBookmarks = UserDefaults.standard.array(forKey: Constants.UserdefaultKey.allbookmark) as? [String] ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        view.backgroundColor = .systemBackground
        title = Constants.ViewStrings.bookMarkTitle
        configureTableView()
        createTabBar()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({make in
            make.bottom.top.equalToSuperview()
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
        })
    }
    
    func deleteBookmarkFromList() {
        UserDefaults.standard.set(arrayOfBookmarks, forKey: Constants.UserdefaultKey.allbookmark)
    }
    
    func createTabBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancleButtonTapped))
        toolbarItems = [spacer, cancelButton]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func cancleButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
