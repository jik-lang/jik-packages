# Jik packages

Official packages for the Jik programming language.

## Usage

Clone this repository and set `JIK_PKG_PATH` to the repository root.

On Windows:

```bat
set JIK_PKG_PATH=C:\path\to\jik-packages
```

On Linux:

```sh
export JIK_PKG_PATH=/path/to/jik-packages
```

Package imports use the `pkg/<name>` path:

```jik
use "pkg/toml"
```

For example, `use "pkg/toml"` resolves to:

```text
<JIK_PKG_PATH>/packages/toml/src/toml.jik
```

Run `jik env` to check the resolved package path. It is printed as
`pkg_path=<path>`.

## Packages

- [`toml`](packages/toml) - small TOML parser

## Testing

```sh
jik run test/tests.jik
```

## Layout

Each package lives under `packages/<name>` and contains its own source, tests, and README.
