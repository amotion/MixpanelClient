import Foundation

/// A URL that hits the Mixpanel API
public struct MixpanelURL {
  /// The endpoint for the API request
  public var endpoint: MixpanelApi.Endpoint
  /// The URL parameters for making queries
  public var parameters: [MixpanelQuery.Parameter?]

  /// The formatted URL for making API calls
  public var url: URL? {
    // Base API
    var urlComponents = MixpanelApi.urlComponents

    // Add endpoint path
    switch self.endpoint {
    case .segmentation:
      urlComponents.path = "\(urlComponents.path)\(MixpanelApi.Endpoint.segmentation.rawValue)"
    }

    // Add parameters
    urlComponents.queryItems = self.parameters.flatMap({ $0?.urlQueryItem })

    return urlComponents.url
  }
}
