import "./sql" for Sql, Connection
import "./crypto" for Md5

var addUser = Fn.new { |db, name, pw|
    var sql = "INSERT OR IGNORE INTO users (username,pass_salt,pass_md5) VALUES(?, ?, ?)"
    var stmt = db.prepare(sql)
    var salt = Sql.randomness(16)
    var md5s = Md5.digest(salt + pw)
    stmt.bindText(1, name)
    stmt.bindText(2, salt)
    stmt.bindText(3, md5s)
    stmt.step()
}

var authenticateUser = Fn.new { |db, name, pw|
    var sql = "SELECT pass_salt, pass_md5 FROM users WHERE username = ?"
    var stmt = db.prepare(sql)
    stmt.bindText(1, name)
    var res = stmt.step()
    if (res != Sql.row) {
        res = false  // no such user
    } else {
        var salt = stmt.columnText(0)
        var passMd5 = stmt.columnText(1)
        res = passMd5 == Md5.digest(salt + pw)
    }
    return res
}

var createSql = """
DROP TABLE IF EXISTS users;
CREATE TABLE users(
userid INTEGER PRIMARY KEY AUTOINCREMENT,
username VARCHAR(32) UNIQUE NOT NULL,
pass_salt tinyblob NOT NULL,
pass_md5 tinyblob NOT NULL);
"""
var db = Connection.open("users.db")
var res = db.exec(createSql)
if (res != Sql.ok) Fiber.abort("Error creating users table.")
addUser.call(db, "user", "password")
System.print("User with correct password: %(authenticateUser.call(db, "user", "password"))")
System.print("User with incorrect password: %(authenticateUser.call(db, "user", "wrong"))")
