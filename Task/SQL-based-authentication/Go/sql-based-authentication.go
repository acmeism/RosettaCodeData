package main

import (
    "bytes"
    "crypto/md5"
    "crypto/rand"
    "database/sql"
    "fmt"

    _ "github.com/go-sql-driver/mysql"
)

func connectDB() (*sql.DB, error) {
    return sql.Open("mysql", "rosetta:code@/rc")
}

func createUser(db *sql.DB, user, pwd string) error {
    salt := make([]byte, 16)
    rand.Reader.Read(salt)
    _, err := db.Exec(`insert into users (username, pass_salt, pass_md5)
        values (?, ?, ?)`, user, salt, saltHash(salt, pwd))
    if err != nil {
        return fmt.Errorf("User %s already exits", user)
    }
    return nil
}

func authenticateUser(db *sql.DB, user, pwd string) error {
    var salt, hash []byte
    row := db.QueryRow(`select pass_salt, pass_md5 from users
        where username=?`, user)
    if err := row.Scan(&salt, &hash); err != nil {
        return fmt.Errorf("User %s unknown", user)
    }
    if !bytes.Equal(saltHash(salt, pwd), hash) {
        return fmt.Errorf("User %s invalid password", user)
    }
    return nil
}

func saltHash(salt []byte, pwd string) []byte {
    h := md5.New()
    h.Write(salt)
    h.Write([]byte(pwd))
    return h.Sum(nil)
}

func main() {
    // demonstrate
    db, err := connectDB()
    defer db.Close()
    createUser(db, "sam", "123")
    err = authenticateUser(db, "sam", "123")
    if err == nil {
        fmt.Println("User sam authenticated")
    }

    // extra
    fmt.Println()
    // show contents of database
    rows, _ := db.Query(`select username, pass_salt, pass_md5 from users`)
    var user string
    var salt, hash []byte
    for rows.Next() {
        rows.Scan(&user, &salt, &hash)
        fmt.Printf("%s %x %x\n", user, salt, hash)
    }
    // try creating same user again
    err = createUser(db, "sam", "123")
    fmt.Println(err)
    // try authenticating unknown user
    err = authenticateUser(db, "pam", "123")
    fmt.Println(err)
    // try wrong password
    err = authenticateUser(db, "sam", "1234")
    fmt.Println(err)
    // clear table to run program again
    db.Exec(`truncate table users`)
}
