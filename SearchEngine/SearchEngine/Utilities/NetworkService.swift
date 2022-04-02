//import UIKit
//
//final class NetworkService {
//    static let shared = NetworkService()
//    
//    private init() {}
//    
//    public func fetchUrlData<T: Codable>(url: URL?, expecting: T.Type,
//                                         completionHandler: @escaping
//                                         (Result<T, Error>) -> Void) {
//        
//        guard let url = url else {
//            completionHandler(.failure(NetworkingError.InvalidUrl))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                if let error = error {
//                    completionHandler(.failure(error)) }
//                else {
//                    completionHandler(.failure(NetworkingError.UnknownError))
//                }
//                return
//            }
//            do {
//                let result = try JSONDecoder().decode(expecting, from: data)
//                completionHandler(.success(result))
//            }
//            catch {
//                completionHandler(.failure(error))
//                print("Error is \(error)")
//            }
//        }
//        task.resume()
//    }
//}
