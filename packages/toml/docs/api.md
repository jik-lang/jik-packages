# TOML API

Public API for `pkg/toml`.

## `TomlValue`

Parsed TOML values are represented by the `TomlValue` variant:

```jik
variant TomlValue:
    INT: int
    STRING: String
    BOOL: bool
end
```

Access a value by checking its variant case:

```jik
value := doc.root["port"]
if value is Some and value? is toml::TomlValue.INT:
    port := value?[toml::TomlValue.INT]
end
```

## `TomlDocument`

`parse` returns a `TomlDocument`:

```jik
struct TomlDocument:
    root: Dict[TomlValue]
    tables: Dict[Dict[TomlValue]]
end
```

Root assignments are stored in `root`:

```jik
port := doc.root["port"]
```

Table assignments are stored in `tables`, keyed first by table name and then by value key:

```jik
server := doc.tables["server"]
if server is Some:
    host := server?["host"]
end
```

## `parse`

```jik
throws func parse(foreign src: String, r: Region) -> TomlDocument
```

Parses TOML source into a document allocated in `r`.

```jik
use "pkg/toml"

func main():
    src := "port = 8080\n[server]\nhost = \"localhost\"\nsecure = true"
    doc := must toml::parse(src, _)

    port := doc.root["port"]
    host := doc.tables["server"]?["host"]
end
```

Unsupported TOML forms return a parse error.
