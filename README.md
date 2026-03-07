# 🗄️ Bash Shell Script Database Management System (DBMS)

A **file-based Database Management System** built entirely in **Bash** — a DevOps-oriented project that demonstrates advanced shell scripting: modular architecture, data validation, file I/O, and a menu-driven CLI that mirrors real DBMS concepts (DDL, DML, DQL).

**Credit:** Youssef_Gaber && Nouran_Ali

---

## 📌 Overview

This project is a **Database Management System (DBMS)** implemented using **Bash Shell Scripting**. It allows users to **create, manage, and manipulate databases and tables** through a **menu-driven CLI**. All data is stored on the **local file system**, simulating how real DBMS engines persist and query data — perfect for understanding database internals while leveling up Bash skills.

---

## 🎯 What This Project Demonstrates (Bash Skills)

| Skill | Where It's Used |
|-------|-----------------|
| **Modular design with `source`** | Each feature lives in its own script; `menu.sh` and `connect_menu.sh` source function files. |
| **Associative & indexed arrays** | `create_table.sh` (columns/types), `insert_into_table.sh` (column metadata), `update_table.sh` (column indices). |
| **Regex validation** | Names (DB, table, column): `^[a-zA-Z0-9_]+$`, integers: `^[1-9][0-9]*$`, `^\-?[0-9]+$` for signed ints. |
| **Structured file I/O** | Metadata (`.meta`) and data (`.data`) with custom delimiter `<\|>`; `while IFS=: read` and `awk -F'<\\|>'`. |
| **ANSI colors & formatting** | `RED`, `GREEN`, `YELLOW`, `BOLD`, `UNDERLINE`, `tput cuu1`/`el` for clean UX. |
| **Conditional logic & guards** | Check DB/table existence, meta/data files, primary key, type checks before every operation. |
| **Reusable condition function** | `condition_check.sh`: `=`, `!=`, `>`, `<` with integer validation; used in `delete_table.sh`. |
| **Process substitution** | `update_table.sh` / `delete_table.sh`: `< <(sed "s/<|>/$temp_delimiter/g" "$data_file")` for safe field splitting. |
| **Awk for querying** | `select_all.sh` (replace delimiter), `select_option.sh` (filter by column, project columns), `insert_into_table.sh` (PK uniqueness). |
| **Confirmation flows** | `drop_db.sh`, `drop_table.sh`, `delete_all_data.sh`: `read -p` with `y/n` and `-1` to cancel. |
| **Here-doc for ASCII art** | `functions_gui.sh`: `cat << "EOF"` for the Bash-DBMS logo. |

---

## 🚀 Features

### Main Menu (Database level)
- **Create Database** — new directory under `DB/DB_Dir/`
- **List Databases** — list all DB directories
- **Connect to Database** — set `Curr_DB`, enter table operations menu
- **Drop Database** — delete DB directory after confirmation

### Database Menu (After connecting — Table level)

| Category | Operation | Description |
|----------|-----------|-------------|
| **DDL** | Create Table | Define columns, types (`int`/`string`), primary key; creates `.meta` + `.data` |
| **DDL** | List Tables | List table directories in current DB |
| **DDL** | Drop Table | Remove table directory after confirmation |
| **DML** | Insert Into Table | Insert one or many rows with type and PK validation |
| **DML** | Update Table | `WHERE col = val` then `SET col = newval` (PK not updatable) |
| **DML** | Delete (specific) | Delete rows matching `WHERE col op value` (`=`, `!=`, `>`, `<`) |
| **DML** | Delete All | Truncate table data (empty `.data` file) |
| **DQL** | Select | Select all, or select with column projection + `WHERE col = value` |

---

## 🧠 Core Concepts

- **Database** → directory under `DB/DB_Dir/<dbname>/`
- **Table** → subdirectory `DB/DB_Dir/<dbname>/<table>/` containing:
  - **`.meta`** — one line per column: `column_name:type:PK|NO` (e.g. `id:int:PK`)
  - **`.data`** — one line per row; fields separated by **`<|>`**
- **Supported types:** `int`, `string`
- **Constraints:** primary key (unique, not null); type validation on insert/update
- **Architecture:** One script per feature; entry points are `menu.sh` (main) and `connect_menu.sh` (table ops)

---

## 📂 Project Structure

```
bash_project/
├── menu.sh                          # Entry point: colors, DB_Dir, sources all DB + GUI functions, main loop
├── README.md
├── .gitignore                       # Ignores ./DB/DB_Dir/ (persisted data)
│
├── DB/
│   ├── DB_Dir/                      # Root for all databases (created by initiate_db)
│   │   └── <dbname>/                # One directory per database
│   │       └── <table>/             # One directory per table
│   │           ├── <table>.meta     # Schema: col:type:PK|NO per line
│   │           └── <table>.data     # Rows: field<|>field<|>...
│   │
│   └── DB_functions/
│       ├── initiate_db.sh           # Create DB_Dir if missing; erase_output (tput)
│       ├── create_db.sh             # Create DB directory with name validation
│       ├── list_db.sh               # List databases (empty check, basename)
│       ├── drop_db.sh               # Drop DB with confirmation
│       ├── connect_db.sh            # List DBs, read name, set Curr_DB, call connect_menu
│       ├── connect_menu.sh          # Table operations menu; sources all connect_functions
│       │
│       └── connect_functions/       # All table-level operations
│           ├── create_table.sh      # Columns, types, PK → .meta + .data
│           ├── list_tables.sh       # List tables in Curr_DB
│           ├── drop_table.sh        # Remove table dir with confirmation
│           ├── insert_into_table.sh # Read .meta, validate types/PK, append to .data
│           ├── update_table.sh      # WHERE + SET; temp file + move
│           ├── delete_table.sh      # WHERE col op value; uses condition_check.sh
│           ├── delete_all_data.sh   # Truncate .data with confirmation
│           ├── condition_check.sh   # condition(): =, !=, >, < (int check)
│           ├── select_table.sh      # Table name → select all or select with option
│           └── select/
│               ├── select_all.sh    # Print header + awk gsub <|> → tab
│               └── select_option.sh # Column selection + WHERE filter (awk)
│
└── GUI/
    └── functions_gui.sh             # drawLogo (ASCII art, colors)
```

---

## 📄 Data Format

**Metadata (`.meta`):**
```
id:int:PK
name:string:NO
age:int:NO
```

**Data (`.data`):**
```
1<|>youssef<|>18
2<|>gaber<|>20
3<|>fathi<|>30
```

The delimiter `<|>` avoids collisions with commas or colons in string data.

---

## 🏃 How to Run

From the project root:

```bash
chmod +x menu.sh
./menu.sh
```

Or:

```bash
bash menu.sh
```

Ensure all paths are run from the **project root** (scripts use relative paths like `./DB/DB_functions/...` and `./DB/DB_Dir`).

---

## 🛠️ Requirements

- **Bash** (tested with `#!/usr/bin/env bash`)
- No extra packages; uses only standard shell utilities (`awk`, `sed`, `tput`, `mkdir`, `read`, etc.)

---

## 📌 Summary

This repo shows how **Bash** can implement a full DBMS-style workflow: DDL (create/drop DB and tables), DML (insert, update, delete), and DQL (select all or with filters). It highlights **modular scripting**, **validation**, **file-based storage**, and **UX** (colors, menus, confirmations) — all skills that translate directly to DevOps automation, tooling, and system scripts.
