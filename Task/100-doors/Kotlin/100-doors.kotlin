fun oneHundredDoors(): List<Int> {
    val doors = BooleanArray(100, { false })
    for (i in 0..99) {
        for (j in i..99 step (i + 1)) {
            doors[j] = !doors[j]
        }
    }
    return doors
        .mapIndexed { i, b -> i to b }
        .filter { it.second }
        .map { it.first + 1 }
}
