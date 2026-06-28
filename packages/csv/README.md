# CSV parser

CSV parser for Jik.

See the [API reference](docs/api.md) for public data types and parsing behavior.

Supported subset:

- single-character delimiters
- newline-separated records using `\n`
- Windows line endings using `\r\n`
- unquoted fields
- quoted fields
- delimiters inside quoted fields
- escaped quotes inside quoted fields using doubled quotes
- empty fields

Example:

```jik
use "pkg/csv"

func main():
    src := "name,age\nAda,36\nGrace,85"
    rows := must csv::parse(src, ',', _)

    name := rows[1][0]
    age := rows[1][1]
end
```

Unsupported CSV forms return a parse error.

## Testing

From the repository root:

```sh
jik run test/tests.jik
```

To run only the CSV package tests:

```sh
jik run packages/csv/test/test_csv.jik
```
