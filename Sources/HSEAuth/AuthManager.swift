import AuthenticationServices
import SafariServices

class AuthManager: NSObject {
    private weak var anchor: ASPresentationAnchor?

    init(with anchor: ASPresentationAnchor) {
        self.anchor = anchor
    }
}

extension AuthManager: ASWebAuthenticationPresentationContextProviding {
    @available(iOS 12.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let anchor = anchor else { preconditionFailure("anchor is not set") }
        return anchor
    }

}

protocol AuthManagerProtocol: class {
    var session: NSObject? { get set }
    var authManager: AuthManager? { get set }
    func auth(url: URL, callbackScheme: String, completion: @escaping (Result<URL, Error>) -> Void)
}

extension AuthManagerProtocol {
    func auth(
        url: URL,
        callbackScheme: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        var resultUrl: URL?
        var error: Error?
        if #available(iOS 12, *) {
            let session = ASWebAuthenticationSession(url: url,
                                                     callbackURLScheme: callbackScheme)
            {
                resultUrl = $0
                error = $1
            }
            if #available(iOS 13.0, *) {
                session.presentationContextProvider = authManager
            }
            session.start()
            self.session = session
        } else {
            let session = SFAuthenticationSession(url: url,
                                                  callbackURLScheme: callbackScheme) {
                resultUrl = $0
                error = $1
            }
            session.start()
            self.session = session
        }
        if let resultUrl = resultUrl {
            completion(.success(resultUrl))
        }
        if let error = error {
            completion(.failure(error))
        }
        preconditionFailure("something wrong")
    }
}
