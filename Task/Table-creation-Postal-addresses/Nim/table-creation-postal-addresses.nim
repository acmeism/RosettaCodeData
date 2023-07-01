import db_sqlite as db
#import db_mysql as db
#import db_postgres as db

const
  connection = ":memory:"
  user = "foo"
  pass = "bar"
  database = "db"

var c = open(connection, user, pass, database)
c.exec sql"""CREATE TABLE address (
  addrID     INTEGER PRIMARY KEY AUTOINCREMENT,
  addrStreet TEXT NOT NULL,
  addrCity   TEXT NOT NULL,
  addrState  TEXT NOT NULL,
  addrZIP    TEXT NOT NULL)"""
c.close()
