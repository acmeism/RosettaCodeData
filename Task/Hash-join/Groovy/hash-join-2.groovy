def hashJoin(table1, col1, table2, col2) {

    def hashed = table1.groupBy { s -> s[col1] }

    table2.collect { r ->
        hashed[r[col2]].collect { s -> s.plus(r) }
    }.flatten()
}
