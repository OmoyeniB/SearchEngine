import UIKit

final class MainViewCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    var navigateToDetailView: ((String) -> Void)?
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
        navigationController.pushViewController(mainViewController, animated: true)
    }
}


//lazy var urlRequest:URLRequest = URLRequest(url: URL(string: "")!)
//let urlString:String = "https://www.youtube.com/"
//let url:URL = URL(string: urlString)!
//urlRequest = URLRequest(url: url)
//
//webKitView.load(urlRequest)
//searchField.text = urlString
