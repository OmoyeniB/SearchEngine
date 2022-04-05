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
//     let book
    }
}
