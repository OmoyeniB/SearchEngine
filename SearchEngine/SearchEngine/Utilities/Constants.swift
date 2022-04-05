import Foundation
import UIKit

enum Constants {
    
    enum SearchString {
        static let arrayOfbase = [".com", ".org", ".net"]
        static let baseUrl = ""
        static let baseString = "https://"
        static let searchQuery = "https://www.google.com/search?q="
        static let dotCom = ".com"
        static let dotOrg = ".org"
        static let dotNet = ".net"
    }
    
    enum ViewStrings {
        static let searchBarplaceholder = "Type here to search..."
        static let bookMarkTitle = "Bookmark"
        static let displayText = "Search App"
    }
    
    enum PopUpAlertString {
        static let popUpTitle = "Alert"
        static let popUpActionTitles = "OK"
        static let networkOutOfCoverage = "Oops!.. something went wrong. Please check your connection and try again"
    }
    
    enum Images {
        static let bookMark = UIImage(systemName: "book")
        static let displayImage = UIImage(named: "searchImage")
        static let filledBookmark = UIImage(systemName: "book.fill")
    }
    
    enum UserdefaultKey {
        static let allbookmark = "allbookmarks"
    }
    
}
