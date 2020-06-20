import Foundation

class Model: AuthManagerProtocol {
    private let clientId: String

    var session: NSObject? = nil
    var authManager: AuthManager?

    init(with clientId: String) {
        self.clientId = clientId
    }

    func auth(_ completion: @escaping (Result<String, Error>) -> Void) {
        guard let authUrl = Constants.authUrl else { preconditionFailure("something wrong") }

        var urlComponents = URLComponents(url: authUrl, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "response_type", value: Constants.responseType),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUrl),
            URLQueryItem(name: "scope", value: Constants.scope.joined(separator: " "))
        ]

        guard let url = urlComponents?.url else { preconditionFailure("something wrong") }

        auth(
            url: url,
            callbackScheme: Constants.redirectScheme) {
                switch $0 {
                case .success(let url):
                    guard
                        let components = URLComponents(url: url,
                                                         resolvingAgainstBaseURL: false),
                        let code = (components.queryItems?
                            .first(where: { $0.name == "code" })
                            .flatMap { $0.value })
                    else { preconditionFailure("something wrong") }
                    completion(.success(code))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
