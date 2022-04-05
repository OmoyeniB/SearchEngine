import UIKit

final class MainViewCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    var naviagteToBookMarkedItem: (() -> Void)?
    var rootViewController: UIViewController {
        navigationController
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods to be coordinated
    
    override func start() {
        navigateToMainView()
    }
    
    func navigateToMainView() {
        let mainViewController = MainViewController()
        mainViewController.navigateToBookmarkedItem = { [weak self] in
            self?.navigateToBookMarkView()
        }
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func navigateToBookMarkView() {
        let bookmarkController = BookMarkViewController()
//        bookmarkController.didAddToBookmark = { [weak self] in
//            self?.naviagteToBookMarkedItem?()
//            }
        bookmarkController.navigateToBookmarkItem = {url in
            self.navigateToViewBookMarkedItem(url: url)
            
        }
        navigationController.pushViewController(bookmarkController, animated: true)
        }
        
    

    
    func navigateToViewBookMarkedItem(url: URLRequest) {
        let bookMarkedItemController = ViewBookMarkedItem()
        bookMarkedItemController.webView.load(url)
        navigationController.pushViewController(bookMarkedItemController, animated: true)
     
    }
}
