import Foundation

struct Constants {
    static let authUrl = URL(string: "https://auth.hse.ru/adfs/oauth2/authorize/")
    static let responseType = "code"
    static let clientId = "9380a222-1306-4306-a692-4daac62cad13"
    static let redirectScheme = "ru.hse.pf://"
    static let redirectUrl = "\(redirectScheme)auth.hse.ru/adfs/oauth2/ios/ru.hse.pf/callback"
    static let scope = ["profile", "openid"]

    private init() {}
}
