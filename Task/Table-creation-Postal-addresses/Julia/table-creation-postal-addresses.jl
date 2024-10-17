using SQLite

db = SQLite.DB()
SQLite.execute!(db, """\
	CREATE TABLE address (
	addrID		INTEGER PRIMARY KEY AUTOINCREMENT,
	addrStreet	TEXT NOT NULL,
	addrCity	TEXT NOT NULL,
	addrState	TEXT NOT NULL,
	addrZIP		TEXT NOT NULL)
	""")
