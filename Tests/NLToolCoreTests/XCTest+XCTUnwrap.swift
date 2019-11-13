import XCTest

// Running `swift test` will fail to compile saying that XCTUnwrap is missing (even using Xcode 11).
// I don't get why since it works inside Xcode and it appears to be in swift-corelibs-xctest (see
// https://github.com/apple/swift-corelibs-xctest/pull/279).
//
// Adding it here does the trick.. For now... 

/// The user info key used by errors so that they are ignored by the XCTest library.
private let XCTestErrorUserInfoKeyShouldIgnore = "XCTestErrorUserInfoKeyShouldIgnore"

/// The error type thrown by `XCTUnwrap` on assertion failure.
private struct XCTestErrorWhileUnwrappingOptional: Error, CustomNSError {
    static var errorDomain: String = XCTestErrorDomain

    var errorCode: Int = 105

    var errorUserInfo: [String : Any] {
        return [XCTestErrorUserInfoKeyShouldIgnore: true]
    }
}

/// Asserts that an expression is not `nil`, and returns its unwrapped value.
///
/// Generates a failure when `expression == nil`.
///
/// - Parameters:
///   - expression: An expression of type `T?` to compare against `nil`. Its type will determine the type of the returned value.
///   - message: An optional description of the failure.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
/// - Returns: A value of type `T`, the result of evaluating and unwrapping the given `expression`.
/// - Throws: An error when `expression == nil`. It will also rethrow any error thrown while evaluating the given expression.
public func XCTUnwrap<T>(_ expression: @autoclosure () throws -> T?,
                         _ message: @autoclosure () -> String = "",
                         file: StaticString = #file,
                         line: UInt = #line) throws -> T {
    switch try expression() {
    case .some(let value):
        return value

    case .none:
        let failureMessage: String
        let providedMessage = message()
        if providedMessage.isEmpty {
            failureMessage = "Expected non-nil value of type \"\(String(describing: T.self))\""
        } else {
            failureMessage = providedMessage
        }

        XCTFail(failureMessage, file: file, line: line)
        throw XCTestErrorWhileUnwrappingOptional()
    }
}
