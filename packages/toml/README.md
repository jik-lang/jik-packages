# TOML parser

TOML parser for Jik.

See the [API reference](docs/api.md) for public data types and access patterns.

Supported subset:

- table headers such as `[server]`
- unquoted keys made of ASCII letters, digits, `_`, and `-`
- integer, string, and boolean values
- basic string escapes: `\b`, `\t`, `\n`, `\f`, `\r`, `\"`, and `\\`
- blank lines and `#` comments outside strings

Example:

```jik
use "pkg/toml"

func main():
    src := "port = 8080\n[server]\nhost = \"localhost\"\nsecure = true"
    doc := must toml::parse(src, _)

    port := doc.root["port"]
    server := doc.tables["server"]
    if server is Some:
        host := server?["host"]
    end
end
```

Unsupported TOML forms return a parse error.

## Testing

From the repository root:

```sh
jik run test/tests.jik
```

To run only the TOML package tests:

```sh
jik run packages/toml/test/test_toml.jik
```
