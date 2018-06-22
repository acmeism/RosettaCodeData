using MySQL
using Nettle  # for md5

function connect_db(uri, user, pw, dbname)
    mydb = mysql_connect(uri, user, pw, dbname)

    const command = """CREATE TABLE IF NOT EXISTS users (
                          userid INT PRIMARY KEY AUTO_INCREMENT,
                          username VARCHAR(32) UNIQUE KEY NOT NULL,
                          pass_salt tinyblob NOT NULL,
                              -- a string of 16 random bytes
                          pass_md5 tinyblob NOT NULL
                              -- binary MD5 hash of pass_salt concatenated with the password
                  );"""
    mysql_execute(mydb, command)
    mydb
end

function create_user(dbh, user, pw)
    mysql_stmt_prepare(dbh, "INSERT IGNORE INTO users (username, pass_salt, pass_md5) values (?, ?, ?);")
    salt = join([Char(c) for c in rand(UInt8, 16)], "")
    passmd5 = digest("md5", salt * user)
    mysql_execute(dbh, [MYSQL_TYPE_VARCHAR, MYSQL_TYPE_VARCHAR, MYSQL_TYPE_VARCHAR], [user, salt, passmd5])
end

function addusers(dbh, userdict)
    for user in keys(userdict)
        create_user(dbh, user, userdict[user])
    end
end

"""
    authenticate_user
Note this returns true if password provided authenticates as correct, false otherwise
"""
function authenticate_user(dbh, username, pw)
    mysql_stmt_prepare(dbh, "SELECT pass_salt, pass_md5 FROM users WHERE username = ?;")
    pass_salt, pass_md5 = mysql_execute(dbh, [MYSQL_TYPE_VARCHAR], [username], opformat=MYSQL_TUPLES)[1]
    pass_md5 == digest("md5", pass_salt * username)
end

const users = Dict("Joan" => "joanspw", "John" => "johnspw", "Mary" => "marpw", "Mark" => "markpw")
const mydb = connect_db("192.168.1.1", "julia", "julia", "mydb")

addusers(mydb, users)
println("""John authenticates correctly: $(authenticate_user(mydb, "John", "johnspw")==false)""")
println("""Mary does not authenticate with password of 123: $(authenticate_user(mydb, "Mary", "123")==false)""")
mysql_disconnect(mydb)
