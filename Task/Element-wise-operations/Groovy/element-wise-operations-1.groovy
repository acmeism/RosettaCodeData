class NaiveMatrix {

    List<List<Number>> contents = []

    NaiveMatrix(Iterable<Iterable<Number>> elements) {
        contents.addAll(elements.collect{ row -> row.collect{ cell -> cell } })
        assertWellFormed()
    }

    void assertWellFormed() {
        assert contents != null
        assert contents.size() > 0
        def nCols = contents[0].size()
        assert nCols > 0
        assert contents.every { it != null && it.size() == nCols }
    }

    Map getOrder() { [r: contents.size() , c: contents[0].size()] }

    void assertConformable(NaiveMatrix that) { assert this.order == that.order }

    NaiveMatrix unaryOp(Closure op) {
        new NaiveMatrix(contents.collect{ row -> row.collect{ cell -> op(cell) } } )
    }
    NaiveMatrix binaryOp(NaiveMatrix m, Closure op) {
        assertConformable(m)
        new NaiveMatrix(
            (0..<(this.order.r)).collect{ i ->
                (0..<(this.order.c)).collect{ j -> op(this.contents[i][j],m.contents[i][j]) }
            }
        )
    }
    NaiveMatrix binaryOp(Number n, Closure op) {
        assert n != null
        new NaiveMatrix(contents.collect{ row -> row.collect{ cell -> op(cell,n) } } )
    }

    def plus = this.&binaryOp.rcurry { a, b -> a+b }

    def minus = this.&binaryOp.rcurry { a, b -> a-b }

    def multiply = this.&binaryOp.rcurry { a, b -> a*b }

    def div = this.&binaryOp.rcurry { a, b -> a/b }

    def mod = this.&binaryOp.rcurry { a, b -> a%b }

    def power = this.&binaryOp.rcurry { a, b -> a**b }

    def negative = this.&unaryOp.curry { - it }

    def recip = this.&unaryOp.curry { 1/it }

    String toString() {
        contents.toString()
    }

    boolean equals(Object other) {
        if (other == null || ! other instanceof NaiveMatrix) return false
        def that = other as NaiveMatrix
        this.contents == that.contents
    }

    int hashCode() {
        contents.hashCode()
    }
}
