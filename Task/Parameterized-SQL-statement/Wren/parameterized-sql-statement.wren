import "./sql" for Connection

var db = Connection.open("rc.db")

var createSql = [
    "DROP TABLE IF EXISTS players",
    "CREATE table players (name, score, active, jerseyNum)",
    "INSERT INTO players VALUES ('Roethlisberger, Ben', 94.1, TRUE,   7)",
    "INSERT INTO players VALUES ('Smith, Alex',         85.3, TRUE,  11)",
    "INSERT INTO players VALUES ('Doe, John',             15, FALSE,  99)",
    "INSERT INTO players VALUES ('Manning, Payton',     96.5, FALSE, 123)"
]

for (sql in createSql) db.exec(sql)

var widths = [22, 7, 7, 9]
System.print("Before update:\n")
db.printTable("SELECT * FROM players", widths)

var updateSql = "UPDATE players SET name = ?, score = ?, active = ? WHERE jerseyNum = 99"
var ps = db.prepare(updateSql)
ps.bindText(1, "Smith, Steve")
ps.bindDouble(2, 42)
ps.bindBool(3, true)
ps.bindInt(4, 99)
ps.step()

System.print("\nAfter update:\n")
db.printTable("SELECT * FROM players", widths)
