import Foundation

/// A Mixpanel API error
public enum MixpanelError: Error {
  case missingURL
  case missingRequiredParameter(String)
  case apiError(Error)
  case invalidURL(String)
}
