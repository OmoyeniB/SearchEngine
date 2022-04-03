import Foundation
import UIKit

class BookmarkTableCell: UITableViewCell {
 
    static let identifier = "cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLink()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bookmarkLink: UILabel = {
       var link = UILabel()
        link.text = "saved link"
//        link.numberOfLines = 1
       return link
    }()
    
    func configureView() {
       
    }
    
    func configureLink() {
        contentView.addSubview(bookmarkLink)
        bookmarkLink.snp.makeConstraints({make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).inset(20)
        })
    }
}
