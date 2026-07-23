# sqlite

Small SQLite wrapper for Jik.

## Types

### `Database`

Opaque SQLite database connection.

**Notes**
- Create it with `open` and close it with `close` after finalizing every statement created from it.

---

### `Statement`

Opaque prepared SQLite statement and query cursor.

**Notes**
- Create it with `prepare`, bind its one-based `?` parameters, and call `step`.
- Each `step` that returns `true` makes one result row available through the zero-based `column_*` functions. When `step` returns `false`, the statement is complete.
- Call `finalize` before closing the database. Statement reset and reuse are not supported. BLOB values are not supported.

## Functions

### `bind_float(statement: Statement, index: int, value: double) -> void`

Bind a floating-point value to a one-based statement parameter index.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.
2. `index: int` - One-based `?` placeholder index.
3. `value: double` - Floating-point value to bind.

---

### `bind_int(statement: Statement, index: int, value: int) -> void`

Bind an integer to a one-based statement parameter index.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.
2. `index: int` - One-based `?` placeholder index.
3. `value: int` - Integer value to bind.

---

### `bind_null(statement: Statement, index: int) -> void`

Bind SQL NULL to a one-based statement parameter index.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.
2. `index: int` - One-based `?` placeholder index.

---

### `bind_text(statement: Statement, index: int, value: String) -> void`

Bind text to a one-based statement parameter index.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.
2. `index: int` - One-based `?` placeholder index.
3. `value: String` - Text value to bind. Foreign parameter.

**Notes**
- SQLite copies the text value before this function returns.

---

### `close(database: Database) -> void`

Close a database connection.

**Behavior**
- Throws on failure.

**Parameters**
1. `database: Database` - Open database handle.

**Notes**
- Finalize every statement created from the database first. A closed database cannot be used again.

---

### `column_float(statement: Statement, index: int) -> double`

Read a zero-based floating-point result column in the current row.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Statement positioned on a result row.
2. `index: int` - Zero-based selected-column index.

**Returns**
- Floating-point value.

---

### `column_int(statement: Statement, index: int) -> int`

Read a zero-based integer result column in the current row.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Statement positioned on a result row.
2. `index: int` - Zero-based selected-column index.

**Returns**
- Integer value.

**Notes**
- Jik integers are 32-bit; this throws if SQLite's integer is out of range.

---

### `column_is_null(statement: Statement, index: int) -> bool`

Return whether a zero-based result column in the current row is SQL NULL.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Statement positioned on a result row.
2. `index: int` - Zero-based selected-column index.

**Returns**
- `bool`

**Notes**
- Call this after `step` returned `true` and before reading a nullable value.

---

### `column_text(statement: Statement, index: int, region: Region) -> String`

Read a zero-based text result column in the current row.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Statement positioned on a result row.
2. `index: int` - Zero-based selected-column index.
3. `region: Region` - Allocation region for the returned string.

**Returns**
- Text value.

**Notes**
- Call `column_is_null` first when SQL NULL must be distinguished from an empty string.

---

### `exec(database: Database, sql: String) -> void`

Execute SQL directly and discard any result rows.

**Behavior**
- Throws on failure.

**Parameters**
1. `database: Database` - Open database handle.
2. `sql: String` - SQL to execute. Foreign parameter.

**Notes**
- Use this for schema changes, direct inserts or updates, and transaction SQL such as `begin`, `commit`, and `rollback`.
- Use `prepare` for a `select` query or whenever a value comes from outside the SQL string.

---

### `finalize(statement: Statement) -> void`

Release a prepared statement and its native SQLite resources.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.

**Notes**
- A finalized statement cannot be used again.

---

### `open(path: String, region: Region) -> Database`

Open a SQLite database file.

**Behavior**
- Throws on failure.

**Parameters**
1. `path: String` - Database file path or `":memory:"`. Foreign parameter.
2. `region: Region` - Allocation region for the returned handle.

**Returns**
- Open database handle.

**Notes**
- Pass `":memory:"` to create a database that exists only until it is closed.

---

### `prepare(database: Database, sql: String, region: Region) -> Statement`

Compile one SQL statement for parameter binding or reading result rows.

**Behavior**
- Throws on failure.

**Parameters**
1. `database: Database` - Open database handle.
2. `sql: String` - One SQL statement, optionally with `?` placeholders. Foreign parameter.
3. `region: Region` - Allocation region for the returned handle.

**Returns**
- Open prepared statement.

**Notes**
- Use `?` placeholders for values that will be supplied with `bind_*`.
- Finalize the returned statement before closing `database`.

---

### `step(statement: Statement) -> bool`

Execute a statement or advance it to its next result row.

**Behavior**
- Throws on failure.

**Parameters**
1. `statement: Statement` - Open prepared statement.

**Returns**
- `true` when a result row is available for `column_*` calls; `false` when execution is complete.

**Notes**
- `false` is the normal successful result for insert, update, and delete statements.
