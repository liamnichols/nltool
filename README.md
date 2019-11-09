# NLTool

A command line interface wrapper around methods from Apple's NaturalLanguage framework.

## Installation

```
mint install liamnichols/nltool
```

## Usage

### Tokenization

```
$ nltool tokenize --help

Usage: nltool tokenize [<input>] [options]

Use this command to tokenize an input string either via the 'input' argument or as stdin.

Examples:
  nltool tokenize --unit word --language en "Hello World!"
  echo "Hello Word!" | nltool tokenize --unit word --language en
  nltool tokenize --unit word --language en < ./hello.txt

Options:
  -c, --count <value>       The maximum number of tokens to return. Useful for limiting the amount of string that is enumerated
  -h, --help                Show help information
  -l, --language <value>    BCP-47 language tag to use (optional)
  -u, --unit <value>        Unit segmentation to tokenize by. Default is 'word'
```

### Tagger

```
$ nltool tagger --help  

Usage: nltool tagger <command> [options]

Commands for interfacing with NLTagger

Commands:
  availableTagSchemes    Lists the default available tag schemes for a given unit and language
  tag                    Tags the input string against the configured tag schemes
```

```
$ nltool tagger tag --help

Usage: nltool tagger tag <scheme> [<input>] [options]

Tags the input string against the configured tag schemes

Options:
  --join-contractions    Contractions will be returned as one token.
  --join-names           Typically, multiple-word names will be returned as multiple tokens, following the standard tokenization practice of the tagger.
  --omit-other           Omit tokens of type Other (non-linguistic items, such as symbols).
  --omit-punctuation     Omit tokens of type Punctuation (all punctuation).
  --omit-whitespace      Omit tokens of type Whitespace (whitespace of all sorts).
  --omit-words           Omit tokens of type Word (items considered to be words).
  -h, --help             Show help information
  -u, --unit <value>     Unit segmentation to tokenize by. Default is 'word'
```
