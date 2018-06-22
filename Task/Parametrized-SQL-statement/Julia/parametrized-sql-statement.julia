using SQLite

name = "Smith, Steve"
jerseys =  Dict("Smith, Steve" => 99)
sqlbool(tf::Bool) = if(tf) "TRUE" else "FALSE" end

db = SQLite.DB() # no filename given, so create an in-memory temporary
SQLite.execute!(db, "create table players (id integer primary key,
                                           name text,
                                           score number,
                                           active bool,
                                           jerseynum integer)")

SQLite.query(db, "INSERT INTO players (name, score, active, jerseynum) values ('Jones, James', 9, 'FALSE', 99)")
SQLite.query(db, "UPDATE players SET name = ?, score = ?, active = ? WHERE jerseynum = ?";
    values = ["Smith, Steve", 42, sqlbool(true), jerseys[name]])

tbl = SQLite.query(db, "SELECT * from players")
println(tbl)
