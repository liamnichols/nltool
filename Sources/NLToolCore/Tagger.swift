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

public struct Tagger {
    public struct Result: Codable {
        public struct Tag: Codable {
            public let value: String
            public let range: Range<Int>
            public let tag: String?
        }

        public let input: String
        public let tags: [Tag]
    }

    public static func availableTagSchemes(for unit: TokenUnit, in language: Language) -> [String] {
        return NLTagger.availableTagSchemes(for: unit.nlTokenUnit, language: language.nlLanguage).map({ $0.rawValue })
    }

    public let input: String
    public let scheme: TagScheme
    public let unit: TokenUnit
    public let omitWords: Bool
    public let omitPunctuation: Bool
    public let omitWhitespace: Bool
    public let omitOther: Bool
    public let joinNames: Bool
    public let joinContractions: Bool
    public let count: Int?

    public init(input: String,
                scheme: TagScheme,
                unit: TokenUnit,
                omitWords: Bool = false,
                omitPunctuation: Bool = false,
                omitWhitespace: Bool = false,
                omitOther: Bool = false,
                joinNames: Bool = false,
                joinContractions: Bool = false,
                count: Int? = nil) {
        self.input = input
        self.scheme = scheme
        self.unit = unit
        self.omitWords = omitWords
        self.omitPunctuation = omitPunctuation
        self.omitWhitespace = omitWhitespace
        self.omitOther = omitOther
        self.joinNames = joinNames
        self.joinContractions = joinContractions
        self.count = count
    }

    func makeTagger() -> NLTagger {
        let tagger = NLTagger(tagSchemes: [scheme.nlTagScheme])

        tagger.string = input

        return tagger
    }

    func makeOptions() -> NLTagger.Options {
        var options: NLTagger.Options = []

        if omitWords {
            options.insert(.omitWords)
        }

        if omitPunctuation {
            options.insert(.omitPunctuation)
        }

        if omitWhitespace {
            options.insert(.omitWhitespace)
        }

        if omitOther {
            options.insert(.omitOther)
        }

        if joinNames {
            options.insert(.joinNames)
        }

        if joinContractions {
            options.insert(.joinContractions)
        }

        return options
    }

    public func tag() throws -> Result {
        let tagger = makeTagger()

        let range = input.startIndex ..< input.endIndex
        let unit = self.unit.nlTokenUnit
        let scheme = self.scheme.nlTagScheme
        let options: NLTagger.Options = makeOptions()

        var tags: [Result.Tag] = []
        tagger.enumerateTags(in: range, unit: unit, scheme: scheme, options: options) { tag, range -> Bool in
            // Store a representation of the tag that we can return
            tags.append(Result.Tag(
                value: String(input[range]),
                range: input.distance(from: input.startIndex, to: range.lowerBound) ..< input.distance(from: input.startIndex, to: range.upperBound),
                tag: tag?.rawValue
            ))

            // Stop if we've reached the quota
            return tags.count != count
        }

        // Return the reuslt object
        return Result(input: input, tags: tags)
    }
}
