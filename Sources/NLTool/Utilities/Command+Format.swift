import SwiftCLI

private let jsonFlag = Flag("--json",
                            description: "Print output in JSON format", defaultValue: false)

private let prettyPrintFlag = Flag("--pretty-print",
                                   description: "Pretty Print JSON output when using --json command", defaultValue: false)

extension Command {
    var json: Flag { jsonFlag }
    var prettyPrint: Flag { prettyPrintFlag }

    var outputFormat: OutputFormat {
        guard json.value else { return .table }
        return .json(pretty: prettyPrint.value)
    }
}

func configureJSONOutputOptions(in cli: CLI) {
    cli.globalOptions.append(jsonFlag)
    cli.globalOptions.append(prettyPrintFlag)
}
