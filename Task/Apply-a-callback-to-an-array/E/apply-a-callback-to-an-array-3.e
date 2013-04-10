def map(func, collection) {
    def output := [].diverge()
    for item in collection {
        output.push(func(item))
    }
    return output.snapshot()
}
println(map(square, array))
