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
import SwiftyTextTable
import NLToolCore

class TokenizeCommand: FlexibleInputCommand {
    let name: String = "tokenize"
    let shortDescription: String = "Segments input text into semantic units"
    var longDescription: String = """
    Use this command to tokenize an input string either via the 'input' argument or as stdin.

    Examples:
        languageTools tokenize --unit word --language en "Hello World!"
        echo "Hello Word!" | languageTools tokenize --unit word --language en
        languageTools tokenize --unit word --language en < ./hello.txt
    """

    let unit: Key<TokenUnit> = Key("-u", "--unit",
                                   description: "Unit segmentation to tokenize by. Default is 'word'",
                                   completion: .none)

    let language: Key<Language> = Key("-l", "--language",
                                      description: "BCP-47 language tag to use (optional)",
                                      completion: .none)

    let count: Key<Int> = Key("-c", "--count",
                              description: "The maximum number of tokens to return. Useful for limiting the amount of string that is enumerated",
                              completion: .none)

    let input = OptionalParameter()

    func execute() throws {
        // Create a tokenizer using the input parameters
        let tokenizer = Tokenizer(
            input: try readInput(),
            unit: unit.value ?? .word,
            language: language.value,
            count: count.value
        )

        // Perform the tokenization
        let result = try tokenizer.tokenize()

        // Print the result to stdout using the desired format
        stdout.print(result, format: outputFormat)
    }
}

