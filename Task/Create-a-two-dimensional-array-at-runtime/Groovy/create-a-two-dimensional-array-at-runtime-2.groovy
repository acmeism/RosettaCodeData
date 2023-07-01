def r = new Random()

System.in.splitEachLine(/,\s*/) { dim ->
    def nrows = dim[0] as int
    def ncols = dim[1] as int

    def a2d = make2d(nrows, ncols)

    def row = r.nextInt(nrows)
    def col = r.nextInt(ncols)
    def val = r.nextInt(nrows*ncols)

    a2d[row][col] = val

    println "a2d[${row}][${col}] == ${a2d[row][col]}"

    a2d.each { println it }
    println()
}
