# SQLite

Small SQLite wrapper for Jik. It exposes database open, SQL execution,
prepared statements, result reading, and close operations.

See the [API reference](docs/api.md) for the public API and statement lifecycle.

The package links a bundled static SQLite archive. Built programs do not need a
separate SQLite DLL or shared library beside the executable.

## Requirements

- Jik 0.1.0-alpha.12 or newer
- Windows x86-64 with MinGW-w64 GCC, or Linux x86-64 with GCC

## Use

```jik
use "pkg/sqlite"

func main():
    database := must sqlite::open(":memory:", _)
    must sqlite::exec(database, "create table item (id integer, name text)")

    insert := must sqlite::prepare(database, "insert into item values (?, ?)", _)
    must sqlite::bind_int(insert, 1, 1)
    must sqlite::bind_text(insert, 2, "Ada")
    must sqlite::step(insert)
    must sqlite::finalize(insert)

    query := must sqlite::prepare(database, "select name from item where id = ?", _)
    must sqlite::bind_int(query, 1, 1)
    if must sqlite::step(query):
        println(must sqlite::column_text(query, 0, _))
    end
    must sqlite::finalize(query)
    must sqlite::close(database)
end
```

## Scope

The wrapper supports database connections, direct SQL execution, prepared
statements, NULL, Jik `int`, `double`, and text values. It does not yet expose
blobs, named-column access, transaction helpers, migrations, or SQLite
extension loading.

## Native library builds

Package users do not build SQLite. The committed target archives are linked
automatically when this package is imported.

Package maintainers must rebuild an archive after changing the SQLite
amalgamation or the `SQLITE_*` compile options.

### Windows

Run this from the repository root in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File packages/sqlite/native/build/build-win64-mingw.ps1
```

The script requires an `x86_64-w64-mingw32` GCC and GNU `ar`. Set `CC` or `AR`
before running it to select non-default tool paths.

### Linux

Run this from the repository root in a Linux shell or WSL:

```sh
bash packages/sqlite/native/build/build-linux-amd64.sh
```

The script requires an x86-64 GNU Linux GCC and GNU `ar`. In WSL, use a Linux
Jik installation to run the package test after building the archive.

Each script writes its archive and a `build-info.txt` file under its target
directory. Commit both files after verifying the package on that target.

The build scripts use `-O2 -DSQLITE_OMIT_LOAD_EXTENSION`. Keep the scripts,
the committed archives, and the documented configuration aligned.

## Testing

Run all package tests from the repository root:

```sh
jik run test/tests.jik
```

To run only SQLite tests:

```sh
jik run packages/sqlite/test/test_sqlite.jik
```

Run the Windows build and test on Windows and the Linux build and test on
Linux. CI should perform the same checks for both targets.
