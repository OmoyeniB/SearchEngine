import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {
    
    lazy var stackView = UIStackView()
    lazy var backButton = UIButton()
    lazy var nextButton = UIButton()
    lazy var searchField = UITextField()
    lazy var webKitView = WKWebView()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    func configureView() {
        configureStackView()
        configureBackButton()
        configureWebKitView()
        configureNextButton()
        configureSearchField()
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
//        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .red
        
        stackView.snp.makeConstraints({make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(view).inset(20)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(50)
//            make.width.equalTo(300)
            
        })
    }
    
    func configureBackButton() {
        stackView.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.isEnabled = false
        backButton.backgroundColor = .yellow
        
        backButton.snp.makeConstraints({make in
            make.left.top.equalTo(stackView)
            make.width.equalTo(40)
        })
    }
    
    func configureSearchField() {
        stackView.addSubview(searchField)
        searchField.placeholder = "Type here to search..."
        searchField.backgroundColor = .lightGray
        searchField.isUserInteractionEnabled = true
        
        searchField.snp.makeConstraints({make in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.center.equalTo(stackView.snp.center)
            make.top.equalTo(stackView)
            
        })
    }
    
    func configureNextButton() {
        stackView.addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.isEnabled = false
        nextButton.backgroundColor = .yellow
        
        nextButton.snp.makeConstraints({make in
           
            make.right.top.equalTo(stackView)
        })
    }
    
    func configureWebKitView() {
        webKitView.backgroundColor = .red
        
        view.addSubview(webKitView)
        webKitView.snp.makeConstraints({ make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
}



