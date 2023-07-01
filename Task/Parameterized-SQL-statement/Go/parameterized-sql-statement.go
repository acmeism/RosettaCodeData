package main

import (
    "database/sql"
    "fmt"

    _ "github.com/mattn/go-sqlite3"
)

func main() {
    db, _ := sql.Open("sqlite3", "rc.db")
    defer db.Close()
    db.Exec(`create table players (name, score, active, jerseyNum)`)
    db.Exec(`insert into players values ("",0,0,"99")`)
    db.Exec(`insert into players values ("",0,0,"100")`)

    // Parameterized
    db.Exec(`update players set name=?, score=?, active=? where jerseyNum=?`,
        "Smith, Steve", 42, true, "99")

    rows, _ := db.Query("select * from players")
    var (
        name      string
        score     int
        active    bool
        jerseyNum string
    )
    for rows.Next() {
        rows.Scan(&name, &score, &active, &jerseyNum)
        fmt.Printf("%3s %12s %3d %t\n", jerseyNum, name, score, active)
    }
    rows.Close()
}
