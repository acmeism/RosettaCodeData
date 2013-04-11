def max([var bestSoFar] + rest) {
    for x ? (x > bestSoFar) in rest {
        bestSoFar := x
    }
    return bestSoFar
}
