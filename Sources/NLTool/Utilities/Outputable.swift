import Foundation
import SwiftyTextTable
import SwiftCLI

protocol TableRepresentable {
    var header: String? { get }
    var columns: [String] { get }
    var values: [[CustomStringConvertible]] { get }
}

private extension TableRepresentable {
    var table: TextTable {
        var table = TextTable(columns: columns.map({ TextTableColumn(header: $0) }), header: header)
        table.addRows(values: values)
        return table
    }
}

private extension Encodable {
    func jsonString(isPretty: Bool) -> String {
        let encoder = JSONEncoder()

        if isPretty {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }

        guard let data = try? encoder.encode(self), let string = String(data: data, encoding: .utf8) else { return "" }
        return string
    }
}

typealias Outputable = Encodable & TableRepresentable

enum OutputFormat {
    case table, json(pretty: Bool)
}

extension WritableStream {
    func print(_ output: Outputable, format: OutputFormat) {
        switch format {
        case .table:
            self.print(output.table.render())
        case .json(let isPretty):
            self.print(output.jsonString(isPretty: isPretty))
        }
    }
}
