fun oneHundredDoors(): List<Int> {
    val doors = BooleanArray(100) { false }

    repeat(doors.size) { i ->
        for (j in i until doors.size step (i + 1)) {
            doors[j] = !doors[j]
        }
    }

    return doors
        .foldIndexed(emptyList()) { i, acc, door ->
            if (door) acc + (i + 1) else acc
        }
}
