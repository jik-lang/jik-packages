#!/usr/bin/env bash
set -euo pipefail

compiler="${CC:-gcc}"
archiver="${AR:-ar}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
native_dir="$(dirname -- "$script_dir")"
source_dir="$native_dir/sqlite-amalgamation-3530300"
source_file="$source_dir/sqlite3.c"
target_dir="$native_dir/sqlite-3530300_linux_amd64"
lib_dir="$target_dir/lib"
archive_file="$lib_dir/libsqlite3.a"
build_dir="$(mktemp -d)"
compile_flags=(-O2 -DSQLITE_OMIT_LOAD_EXTENSION)

cleanup() {
    rm -rf -- "$build_dir"
}
trap cleanup EXIT

if [[ ! -f "$source_file" ]]; then
    echo "SQLite source not found: $source_file" >&2
    exit 1
fi

compiler_target="$("$compiler" -dumpmachine)"
if [[ "$compiler_target" != x86_64*-linux-gnu ]]; then
    echo "expected an x86_64 Linux GNU compiler, got: $compiler_target" >&2
    exit 1
fi

mkdir -p "$lib_dir"
"$compiler" "${compile_flags[@]}" -c "$source_file" -o "$build_dir/sqlite3.o"
"$archiver" rcsD "$archive_file" "$build_dir/sqlite3.o"

source_hash="$(sha256sum "$source_file" | awk '{print $1}')"
archive_hash="$(sha256sum "$archive_file" | awk '{print $1}')"
compiler_version="$("$compiler" --version | head -n 1)"
archiver_version="$("$archiver" --version | head -n 1)"
host="$(uname -srmo)"
build_time="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat > "$target_dir/build-info.txt" <<EOF
sqlite_version=3.53.3
source_file=sqlite-amalgamation-3530300/sqlite3.c
source_sha256=$source_hash
archive_file=lib/libsqlite3.a
archive_sha256=$archive_hash
target=$compiler_target
compiler=$compiler_version
archiver=$archiver_version
compile_flags=${compile_flags[*]}
host=$host
built_at_utc=$build_time
EOF

printf 'Built %s\n' "$archive_file"
