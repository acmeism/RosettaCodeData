import db_sqlite

let db = open(":memory:", "", "", "")

# Setup
db.exec(sql"CREATE TABLE players (name, score, active, jerseyNum)")
db.exec(sql"INSERT INTO players VALUES (?, ?, ?, ?)", "name", 0, "false", 99)

# Update the row.
db.exec(sql"UPDATE players SET name=?, score=?, active=? WHERE jerseyNum=?",
        "Smith, Steve", 42, true, 99)

# Display result.
for row in db.fastRows(sql"SELECT * FROM players"):
  echo row

db.close()
