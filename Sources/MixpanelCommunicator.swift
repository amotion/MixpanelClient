import Foundation

public protocol MixpanelCommunicatorDelegate: class {
  /// Returns a URL credential with the Mixpanel API secret
  func mixpanelCommunicatorWantsURLCredential(_ mixpanelCommunicator: MixpanelCommunicator) -> URLCredential
}

/// Makes requests to the Mixpanel API given a MixpanelURL
public class MixpanelCommunicator: NSObject {

  private var session = URLSession()
  private let configuration = URLSessionConfiguration.default

  weak public var delegate: MixpanelCommunicatorDelegate?

  public override init() {
    super.init()

    self.session = URLSession(configuration: self.configuration, delegate: self, delegateQueue: nil)
  }

  private func fetch(url: MixpanelURL, completion: @escaping (MixpanelError?, MixpanelData?) -> Void) {
    guard let urlString = url.url else {
      completion(.invalidURL("Unable to make URL for \(url.endpoint) with parameters \(url.parameters)"), nil)
      return
    }

    self.session.dataTask(with: urlString) { (dataOrNil, responseOrNil, errorOrNil) in
      var response: MixpanelData?
      var error: MixpanelError?
      if let sessionError = errorOrNil {
        error = .apiError(sessionError)
      }
      if let data = dataOrNil,
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
        response = MixpanelData(json: json)
      }
      completion(error, response)
      }.resume()
  }

  /// Performs a MixpanelQuery by calling the API
  public func perform(query: MixpanelQuery, completion: @escaping (MixpanelError?, MixpanelData?) -> Void) {
    guard let url = query.url else {
      completion(MixpanelError.missingURL, nil)
      return
    }
    guard query.errors == nil else {
      completion(query.errors?.first, nil)
      return
    }
    self.fetch(url: url, completion: completion)
  }
}

extension MixpanelCommunicator: URLSessionDataDelegate {
  public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    completionHandler(.useCredential, self.delegate?.mixpanelCommunicatorWantsURLCredential(self))
  }
}
