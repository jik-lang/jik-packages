# CSV API

Public API for `pkg/csv`.

`parse` returns a vector of rows. Each row is a vector of string fields:

```jik
name := rows[1][0]
age := rows[1][1]
```

## `parse`

```jik
throws func parse(foreign src: String, delimiter: char, r: Region) -> Vec[Vec[String]]
```

Parses CSV source into a document allocated in `r`. Pass `','` for normal comma-separated values, or another valid delimiter such as `';'`.

```jik
use "pkg/csv"

func main():
    src := "name;age\nAda;36"
    rows := must csv::parse(src, ';', _)

    name := rows[1][0]
end
```

The delimiter cannot be `"`, `\n`, or `\r`.

Unsupported CSV forms return a parse error, including unmatched quotes, text after a closing quote, quotes inside unquoted fields, bare carriage returns, and multiline quoted fields.
