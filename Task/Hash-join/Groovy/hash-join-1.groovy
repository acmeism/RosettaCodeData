def hashJoin(table1, col1, table2, col2) {

    def hashed = table1.groupBy { s -> s[col1] }

    def q = [] as Set

    table2.each { r ->
        def join = hashed[r[col2]]
        join.each { s ->
            q << s.plus(r)
        }
    }

    q
}
