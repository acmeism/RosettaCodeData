#!/bin/sh -f
awk '
BEGIN {
    "echo \"create table pow (name, rank, serno);\" |sqlite3 pow.db" | getline
    print "Result: " $0
    exit;
}
'
