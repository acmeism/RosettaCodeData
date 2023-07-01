#!/bin/sh -f
awk '
BEGIN {
    print "Creating table..."
    dbExec("address.db", "create table address (street, city, state, zip);")
    print "Done."
    exit
}

function dbExec(db, qry,      result) {
    dbMakeQuery(db, qry) | getline result
    dbErrorCheck(result)
}

function dbMakeQuery(db, qry,      q) {
    q = dbEscapeQuery(qry) ";"
    return "echo \"" q "\" | sqlite3 " db
}

function dbEscapeQuery(qry,      q) {
    q = qry
    gsub(/"/, "\\\"", q)
    return q
}

function dbErrorCheck(res) {
    if (res ~ "SQL error") {
        print res
        exit
    }
}

'
