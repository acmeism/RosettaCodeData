(2..6).each { order ->
    def iMatrix = makeIdentityMatrix(order)
    iMatrix.each { println it }
    println()
}
