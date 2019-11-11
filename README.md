# NLTool

A command line interface wrapper around methods from Apple's NaturalLanguage framework.

## Installation

```
mint install liamnichols/nltool
```

## Usage

Use `nltool --help` for a list of commands and options. The two main supported commands are `tokenize` and `tagger tag`.

### Examples

Pipe an input string and tag its contents:

```
$ curl -s http://whatthecommit.com/index.txt | nltool tagger tag LexicalClass --omit-whitespace --omit-punctuation
+------------------------------------+
| Tags for Lexicalclass (Word)       |
+------------------------------------+
| Index | Range   | Tag      | Value |
+-------+---------+----------+-------+
| 0     | 0..<5   | Adverb   | Never |
| 1     | 6..<11  | Verb     | gonna |
| 2     | 12..<16 | Verb     | give  |
| 3     | 17..<20 | Pronoun  | you   |
| 4     | 21..<23 | Particle | up    |
+-------+---------+----------+-------+
```

See the built-in tag schemes available for a given token unit and language:

```
$ nltool tagger availableTagSchemes word en
+-------------------------------------+
| Available Tag Schemes for Word (en) |
+-------------------------------------+
| Language                            |
| Script                              |
| TokenType                           |
| NameType                            |
| LexicalClass                        |
| NameTypeOrLexicalClass              |
| Lemma                               |
+-------------------------------------+
```

Output the results in JSON format:

```
$ nltool tokenize "First sentence. Second Sentence" --unit sentence --json --pretty-print
{
  "input" : "First sentence. Second Sentence",
  "tokens" : [
    {
      "attributes" : [

      ],
      "range" : [
        0,
        16
      ],
      "value" : "First sentence. "
    },
    {
      "attributes" : [

      ],
      "range" : [
        16,
        31
      ],
      "value" : "Second Sentence"
    }
  ],
  "unit" : "sentence"
}
```

View help infromation for any command with `--help`:

```
$ nltool tagger tag --help                                                                   

Usage: nltool tagger tag <scheme> [<input>] [options]

Tags the input string against the configured tag schemes

Options:
  --join-contractions    Contractions will be returned as one token.
  --join-names           Typically, multiple-word names will be returned as multiple tokens, following the standard tokenization practice of the tagger.
  --json                 Print output in JSON format
  --omit-other           Omit tokens of type Other (non-linguistic items, such as symbols).
  --omit-punctuation     Omit tokens of type Punctuation (all punctuation).
  --omit-whitespace      Omit tokens of type Whitespace (whitespace of all sorts).
  --omit-words           Omit tokens of type Word (items considered to be words).
  --pretty-print         Pretty Print JSON output when using --json command
  -h, --help             Show help information
  -u, --unit <value>     Unit segmentation to tokenize by. Default is 'word'
```
