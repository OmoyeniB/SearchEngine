import UIKit

final class BookmarksCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        loadBookmarks()
    }

    func loadBookmarks() {

    }
//    func showNewsDetail(article: Article) {
//        let newsDetailsController = NewsDetailsViewController.instantiate()
//        newsDetailsController.article = article
//        navigationController.pushViewController(newsDetailsController, animated: true)
//    }
}
