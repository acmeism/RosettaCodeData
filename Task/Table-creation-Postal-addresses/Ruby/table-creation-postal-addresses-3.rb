require 'sqlite3'

db = SQLite3::Database.new(':memory:')
db.execute("
    CREATE TABLE address (
        addrID     INTEGER PRIMARY KEY AUTOINCREMENT,
        addrStreet TEXT NOT NULL,
        addrCity   TEXT NOT NULL,
        addrState  TEXT NOT NULL,
        addrZIP    TEXT NOT NULL
    )
")
