import Foundation

enum NetworkingError: LocalizedError {
    case ErrorDecoding
    case UnknownError
    case InvalidUrl
    case ServerError(String)
    
    var errorDescription: String? {
        switch self {
        case .ErrorDecoding:
                return Constants.errorDecoding
        case .UnknownError:
                return Constants.unkownError
        case .InvalidUrl:
                return Constants.invalidUrl
        case .ServerError(let error):
            return error
        }
    }
}
