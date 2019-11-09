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

import NaturalLanguage

public struct Tokenizer {
    public struct Result: Codable {
        public struct Token: Codable {
            public let value: String
            public let range: Range<Int>
            public let attributes: [TokenizerAttribute]
        }

        public let input: String
        public let tokens: [Token]
    }

    public let input: String
    public let unit: TokenUnit
    public let language: Language?
    public let count: Int?

    public init(input: String, unit: TokenUnit, language: Language? = nil, count: Int? = nil) {
        self.input = input
        self.unit = unit
        self.language = language
        self.count = count
    }

    func makeTokenizer() -> NLTokenizer {
        // Create the underlying tokenizer
        let tokenizer = NLTokenizer(unit: unit.nlTokenUnit)

        // Set a language if it was provided
        if let language = language?.nlLanguage {
            tokenizer.setLanguage(language)
        }

        // Pass the input into the tokenizer
        tokenizer.string = input

        // Return the created instnace ready for use
        return tokenizer
    }

    public func tokenize() throws -> Result {
        let tokenizer = makeTokenizer()

        var results: [Result.Token] = []
        tokenizer.enumerateTokens(in: input.startIndex ..< input.endIndex) { range, attributes -> Bool in
            // Append a Token representation
            results.append(Result.Token(
                value: String(input[range]),
                range: input.distance(from: input.startIndex, to: range.lowerBound) ..< input.distance(from: input.startIndex, to: range.upperBound),
                attributes: TokenizerAttribute.from(nlTokenizerAttributes: attributes)
            ))

            // Stop if we've reached the quota
            return results.count != count
        }

        return Result(input: input, tokens: results)
    }
}
