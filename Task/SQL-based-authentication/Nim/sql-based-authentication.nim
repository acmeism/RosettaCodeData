import db_mysql, nimcrypto, md5, strutils

proc connectDb(user, password: string): DbConn =
  ## Connect to the database "user_db" and create
  ## the table "users" if it doesn’t exist yet.

  result = open("localhost", user, password, "user_db")
  result.exec(sql"""CREATE TABLE IF NOT EXISTS users (
                      userid INT PRIMARY KEY AUTO_INCREMENT,
                      username VARCHAR(32) UNIQUE KEY NOT NULL,
                      pass_salt tinyblob NOT NULL,
                      pass_md5 tinyblob NOT NULL)""")


proc createUser(db: DbConn; username, password: string) =
  ## Create a new user in the table "users".
  ## The password salt and the password MD5 are managed as strings
  ## but stored in tinyblobs as required.
  var passSalt = newString(16)
  if randomBytes(passSalt) != 16:
    raise newException(ValueError, "unable to build a salt.")
  var passMd5 = newString(16)
  for i, b in toMD5(passSalt & password): passMd5[i] = chr(b)
  if db.tryExec(sql"INSERT INTO users (username, pass_salt, pass_md5) VALUES (?, ?, ?)",
                username, passSalt, passMd5):
    echo "User $1 created." % username
  else:
    echo "Could not create user $1." % username


proc authenticateUser(db: DbConn; user, password: string): bool =
  ## Try to authenticate the user.
  ## The authentication fails if the user doesn’t exist in "users" table or if the
  ## password doesn’t match with the salt and password MD5 retrieved from the table.
  let row = db.getRow(sql"SELECT pass_salt, pass_md5 FROM users WHERE username = ?", user)
  if row[0].len != 0:
    let digest = toMd5(row[0] & password)
    for i in 0..15:
      if digest[i] != byte(row[1][i]): return
    result = true

proc clean(db: DbConn) =
  ## Remove all users from "users" table.
  db.exec(sql"DELETE FROM user_db.users")


when isMainModule:

  proc authResult(status: bool): string =
    if status: "Succeeded" else: "Failed"

  # Connect to database and create user "Alice".
  let db = connectDb("admin", "admin_password")
  db.createUser("Alice", "Alice_password")

  # Try to authenticate Alice...
  # ... with a wrong password...
  var result = db.authenticateUser("Alice", "another_password").authResult()
  echo result, " to authenticate Alice with a wrong password."
  # ... then with the right password.
  result = db.authenticateUser("Alice", "Alice_password").authResult()
  echo result, " to authenticate Alice with the right password."

  # Clean-up and close.
  db.clean()
  db.close()
