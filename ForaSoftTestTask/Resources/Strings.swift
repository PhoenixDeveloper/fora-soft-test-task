// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum AlbumCell {
    /// A singer: %@
    internal static func artistName(_ p1: Any) -> String {
      return L10n.tr("Localizable", "AlbumCell.artistName", String(describing: p1))
    }
    /// Number of tracks: %d
    internal static func countSongs(_ p1: Int) -> String {
      return L10n.tr("Localizable", "AlbumCell.countSongs", p1)
    }
    /// Genre: %@
    internal static func genre(_ p1: Any) -> String {
      return L10n.tr("Localizable", "AlbumCell.genre", String(describing: p1))
    }
  }

  internal enum Error {
    /// An application error has occurred. Please update your application in AppStore or inform customer service
    internal static let clientError = L10n.tr("Localizable", "Error.clientError")
  }

  internal enum ListAlbums {
    internal enum EmptyState {
      /// No search results
      internal static let text = L10n.tr("Localizable", "ListAlbums.EmptyState.text")
    }
    internal enum SearchBar {
      /// Search albums...
      internal static let placeholder = L10n.tr("Localizable", "ListAlbums.SearchBar.placeholder")
    }
  }

  internal enum ListSongs {
    /// List of songs
    internal static let songsList = L10n.tr("Localizable", "ListSongs.songsList")
  }

  internal enum SongCell {
    /// Duration: %@
    internal static func duration(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SongCell.duration", String(describing: p1))
    }
    /// A singer: %@
    internal static func singer(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SongCell.singer", String(describing: p1))
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
