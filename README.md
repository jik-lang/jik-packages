# Jik packages

<a href="https://github.com/jik-lang/jik-packages/actions/workflows/test.yml"><img alt="Test" src="https://github.com/jik-lang/jik-packages/actions/workflows/test.yml/badge.svg?branch=main"></a>

Official packages for the [Jik programming language](https://jik-lang.org).

The Jik compiler and command-line toolchain can be found [here](https://github.com/jik-lang/jik).

## Packages

- [`argparse`](packages/argparse) - command-line argument parser
- [`csv`](packages/csv) - CSV parser
- [`raylib`](packages/raylib) - Small 2D raylib wrapper
- [`toml`](packages/toml) - TOML parser
- [`sqlite`](packages/sqlite) - sqlite3 wrapper

## Compatibility

This package set requires Jik >= 0.1.0-alpha.12.

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

## Testing

```sh
jik run test/tests.jik
```

## Layout

Each package lives under `packages/<name>` and contains its own source, tests, and README.
