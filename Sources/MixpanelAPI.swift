import Foundation

/// Holds the constants for constructing API URLs
public struct MixpanelApi {
  static let host = "mixpanel.com"
  static let path = "/api/2.0"

  /// The base URLComponents object with the correct Mixpanel host and path
  static var urlComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = MixpanelApi.host
    urlComponents.path = MixpanelApi.path

    return urlComponents
  }

  /// Endpoints for the Mixpanel API along with their required keys
  public enum Endpoint: String {
    case segmentation = "/segmentation"

    public var requiredKeys: [MixpanelQuery.Parameter.URLKey] {
      switch self {
      case .segmentation:
        return [
          .event,
          .fromDate,
          .toDate
        ]
      }
    }
  }
}
