import Foundation

/// Holds the data returned from the Mixpanel API
public struct MixpanelData {
  /*
  TODO: The API response data changes per endpoint, so this should be a protocol
  for other specific response data types
  */
  public let series: [String]
  public let values: [String: Any]
}

extension MixpanelData {
  /// Initialize a MixpanelData object from JSON
  init?(json: [String: Any]) {
    guard let _ = json["legend_size"] as? Int,
      let data = json["data"] as? [String: Any],
      let series = data["series"] as? [String],
      let values = data["values"] as? [String: Any] else {
        return nil
    }

    self.series = series
    self.values = values
  }
}
