import NLToolCore
import SwiftyTextTable

extension Tagger.Result: TableRepresentable {
    var header: String? {
        "Tags for \(scheme.rawValue.capitalized) (\(unit.rawValue.capitalized))"
    }

    var columns: [String] {
        ["Index", "Range", "Tag", "Value"]
    }

    var values: [[CustomStringConvertible]] {
        tags.enumerated().map({ [$0.offset, $0.element.range, $0.element.tag ?? "", $0.element.value] })
    }
}
