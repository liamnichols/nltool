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

import Foundation
import SwiftCLI
import NLToolCore

extension TaggerCommand {
    class Tag: FlexibleInputCommand {
        let name: String = "tag"
        let shortDescription: String = "Tags the input string against the configured tag schemes"

        let unit: Key<TokenUnit> = Key(
            "-u", "--unit",
            description: "Unit segmentation to tokenize by. Default is 'word'",
            completion: .none
        )

        let scheme = Param.Required<TagScheme>()

        let omitWords = Flag(
            "--omit-words",
            description: "Omit tokens of type Word (items considered to be words).",
            defaultValue: false
        )

        let omitPunctuation = Flag(
            "--omit-punctuation",
            description: "Omit tokens of type Punctuation (all punctuation).",
            defaultValue: false
        )

        let omitWhitespace = Flag(
            "--omit-whitespace",
            description: "Omit tokens of type Whitespace (whitespace of all sorts).",
            defaultValue: false
        )

        let omitOther = Flag(
            "--omit-other",
            description: "Omit tokens of type Other (non-linguistic items, such as symbols).",
            defaultValue: false
        )

        let joinNames = Flag(
            "--join-names",
            description: "Typically, multiple-word names will be returned as multiple tokens, following the standard tokenization practice of the tagger.",
            defaultValue: false
        )

        let joinContractions = Flag(
            "--join-contractions",
            description: "Contractions will be returned as one token.",
            defaultValue: false
        )

        let input = OptionalParameter()

        func execute() throws {
            // Create a tagger using the input arguments
            let tagger = Tagger(
                input: try readInput(),
                scheme: scheme.value,
                unit: unit.value ?? .word,
                omitWords: omitWords.value,
                omitPunctuation: omitPunctuation.value,
                omitWhitespace: omitWhitespace.value,
                omitOther: omitOther.value,
                joinNames: joinNames.value,
                joinContractions: joinContractions.value
            )

            // Perform the tag operation
            let result = try tagger.tag()

            // TODO: Standardise output formatting...
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(result)
            let string = String(data: data, encoding: .utf8)!
            stdout <<< string
        }
    }
}

