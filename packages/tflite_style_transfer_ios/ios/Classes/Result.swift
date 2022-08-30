import Foundation

/// Convenient enum to return result with a callback
enum Result<T> {
    case success(T)
    case error(Error)
}
