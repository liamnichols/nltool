/// MIT License
///
/// Copyright (c) 2019 Liam Nichols
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import SwiftCLI
import NLToolCore

extension TaggerCommand {
    class AvailableTagSchemes: Command {
        let name: String = "availableTagSchemes"
        let shortDescription: String = "Lists the default available tag schemes for a given unit and language"

        let unit = Param.Required<TokenUnit>(completion: .none)
        let language = Param.Required<Language>(completion: .none)
        
        func execute() throws {
            let results = Tagger.availableTagSchemes(for: unit.value, in: language.value)
            let result = AvailableTagSchemesResult(unit: unit.value, language: language.value, results: results)
            stdout.print(result, format: outputFormat)
        }
    }
}

// TODO: Make this nicer
struct AvailableTagSchemesResult: Outputable {
    let unit: TokenUnit
    let language: Language
    let results: [String]

    var header: String? { nil }

    var columns: [String] { ["Available Tag Schemes for \(unit.rawValue.capitalized) (\(language.rawValue))"] }

    var values: [[CustomStringConvertible]] { results.map({ [$0] }) }
}
