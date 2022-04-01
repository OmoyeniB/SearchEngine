import UIKit

final class MainCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }
    
    override func start() {
        navigateToMainView()
    }
    
    func navigateToMainView() {

        let mainViewCoordinator = MainViewCoordinator(navigationController: navigationController)
        pushCoordinator(mainViewCoordinator)
        window.rootViewController = mainViewCoordinator.rootViewController
        window.makeKeyAndVisible()
//
        mainViewCoordinator.didFinish = { [weak self] coordinator in
            self?.popCoordinator(coordinator)
        }
//        mainViewCoordinator.navigateToDetailView = {index in
//            self.navigateToDetailsView(cellId: index)
//        }
    }
    
}
