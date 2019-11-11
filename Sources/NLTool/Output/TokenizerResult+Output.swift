import NLToolCore
import SwiftyTextTable

extension Tokenizer.Result: TableRepresentable {
    var header: String? {
        "\(unit.rawValue.capitalized) Segments"
    }

    var columns: [String] {
        ["Index", "Range", "Segment"]
    }

    var values: [[CustomStringConvertible]] {
        tokens.enumerated().map({ [$0.offset, $0.element.range, $0.element.value] })
    }
}
