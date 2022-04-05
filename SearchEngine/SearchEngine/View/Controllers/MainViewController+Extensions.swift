import UIKit
import WebKit

extension MainViewController {
    
    func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(progressView)
        view.addSubview(scrollView)
        view.addSubview(contentView)
        stackView.addSubview(backButton)
        stackView.addSubview(containerView)
        containerView.addSubview(nextButton)
        containerView.addSubview(topBookMarkButton)
        stackView.addSubview(searchBar)
        contentView.addSubview(webKitView)
        webKitView.addSubview(displayImage)
        webKitView.addSubview(displayText)
        
        configureStackView()
        configureProgressBar()
        configureBackButton()
        configureSearchField()
        configureContainerView()
        configureNextButton()
        configureBookMark()
        configureScrollView()
        configureWebKitView()
        configureContentView()
        configureDisplayImage()
        configureDisplayText()
    }
    
    func modelsToModifyView() {
        swipeView()
        didPullToRefresh()
        setupEstimatedProgressObserver()
        createToolBarItems()
    }
    
    func configureStackView() {
        stackView.snp.makeConstraints({make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(view).inset(10)
            make.left.equalTo(view).offset(10)
            make.height.equalTo(50)
        })
    }
    
    func configureProgressBar() {
        progressView.isHidden = true
        progressView.snp.makeConstraints({ make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(5)
        })
    }
    
    func configureBackButton() {
        backButton.snp.makeConstraints({make in
            make.left.top.equalTo(stackView)
            make.width.equalTo(40)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureContainerView() {
        containerView.snp.makeConstraints({make in
            make.top.equalTo(stackView)
            make.left.equalTo(searchBar.snp.right).offset(20)
            make.right.equalTo(stackView).inset(10)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureBookMark() {
        topBookMarkButton.snp.makeConstraints({ make in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureNextButton() {
        nextButton.snp.makeConstraints({make in
            make.top.equalTo(containerView)
            make.left.equalTo(topBookMarkButton.snp.right).offset(10)
            make.right.equalTo(containerView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureSearchField() {
        searchBar.snp.makeConstraints({make in
            make.left.equalTo(backButton.snp.right).offset(5)
            make.top.equalTo(stackView)
            make.height.equalTo(stackView.snp.height)
        })
    }
    
    func configureScrollView() {
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    func configureContentView() {
        contentView.snp.makeConstraints({ make in
            make.top.bottom.equalTo(scrollView)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.centerX.equalTo(scrollView)
            make.centerY.equalTo(scrollView)
        })
    }
    
    func configureWebKitView() {
        webKitView.snp.makeConstraints({ make in
            make.edges.equalTo(contentView)
        })
    }
    
    func configureDisplayImage() {
        displayImage.snp.makeConstraints{ make in
            make.top.equalTo(webKitView).offset(40)
            make.leading.equalTo(webKitView).offset(20)
            make.trailing.equalTo(webKitView).inset(20)
            make.height.equalTo(300)
        }
    }
    
    func configureDisplayText() {
        displayText.snp.makeConstraints({ make in
            make.top.equalTo(displayImage.snp.bottom).offset(20)
            make.center.equalTo(webKitView)
        })
    }
}
