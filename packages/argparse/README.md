# Argparse

Small command-line argument parser for Jik.

See the [API reference](docs/api.md) for public data types and parsing rules.

Example:

```jik
use "pkg/argparse"

func main(args):
    ap := argparse::new(_)
    argparse::add_positional(ap, "input", "Input file.")

    output := argparse::add_option(ap, "--output", "-o", "Output file.")
    argparse::add_option_positional(output, "file", "Output path.")

    argparse::add_option(ap, "--verbose", "-v", "Show extra output.")
    result := must argparse::parse(ap, args, _)

    input := result.positionals["input"]?
    output_path := result.options["--output"]?["file"]?
    if result.options["--verbose"] is Some:
        println("Reading ", input)
    end
end
```

Options use both a long spelling, such as `--output`, and a short spelling,
such as `-o`. An option without declared values is a flag.

## Testing

From the repository root:

```sh
jik run test/tests.jik
```
