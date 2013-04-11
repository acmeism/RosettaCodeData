def test = { crossProduct ->

    def scalarTripleProduct = { x, y, z ->
        dotProduct(x, crossProduct(y, z))
    }

    def vectorTripleProduct = { x, y, z ->
        crossProduct(x, crossProduct(y, z))
    }

    def a = [3, 4, 5]
    def b = [4, 3, 5]
    def c = [-5, -12, -13]

    println("      a . b = " + dotProduct(a,b))
    println("      a x b = " + crossProduct(a,b))
    println("a . (b x c) = " + scalarTripleProduct(a,b,c))
    println("a x (b x c) = " + vectorTripleProduct(a,b,c))
    println()
}

test(crossProductS)
test(crossProductV)
