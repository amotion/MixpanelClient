import Foundation

public struct MixpanelQuery {
  /// URL to query the Mixpanel API
  public var url: MixpanelURL?

  /// Validation errors
  public var errors: [MixpanelError]? {
    guard let url = self.url else {
      return [MixpanelError.missingURL]
    }

    var errors: [MixpanelError] = []
    url.endpoint.requiredKeys.filter { key in
        !url.parameters.flatMap({ $0?.urlKey }).contains(key)
      }
      .forEach({
        errors.append(MixpanelError.missingRequiredParameter($0.rawValue))
      })

    return (errors.count > 0 ? errors : nil)
  }

  /// Parameter used for querying data
  public enum Parameter {
    case event(String)
    case fromDate(String)
    case toDate(String)
    case unit(String)
    case interval(String)

    /// Key used in the URL parameter
    public enum URLKey: String {
      case event = "event"
      case fromDate = "from_date"
      case toDate = "to_date"
      case unit = "unit"
      case interval = "interval"
    }

    public var urlKey: URLKey {
      switch self {
      case .event:
        return .event
      case .fromDate:
        return .fromDate
      case .toDate:
        return .toDate
      case .unit:
        return .unit
      case .interval:
        return .interval
      }
    }

    /// Returns a URLQueryItem for use in URLComponents
    public var urlQueryItem: URLQueryItem {
      switch self {
      case .event(let eventName):
        return URLQueryItem(name: MixpanelQuery.Parameter.URLKey.event.rawValue, value: eventName)
      case .fromDate(let date):
        return URLQueryItem(name: MixpanelQuery.Parameter.URLKey.fromDate.rawValue, value: date)
      case .toDate(let date):
        return URLQueryItem(name: MixpanelQuery.Parameter.URLKey.toDate.rawValue, value: date)
      case .unit(let unit):
        return URLQueryItem(name: MixpanelQuery.Parameter.URLKey.unit.rawValue, value: unit)
      case .interval(let interval):
        return URLQueryItem(name: MixpanelQuery.Parameter.URLKey.interval.rawValue, value: interval)
      }
    }
  }
}

extension MixpanelQuery {
  public init(url: MixpanelURL) {
    self.url = url
  }

  /// Access the Segmentation API
  public static func segmentation(_ parameters: [MixpanelQuery.Parameter]) -> MixpanelQuery {
    return MixpanelQuery(url: MixpanelURL(endpoint: .segmentation, parameters: parameters))
  }
}
