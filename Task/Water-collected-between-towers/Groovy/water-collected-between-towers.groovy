Integer waterBetweenTowers(List<Integer> towers) {
    // iterate over the vertical axis. There the amount of water each row can hold is
    // the number of empty spots, minus the empty spots at the beginning and end
    return (1..towers.max()).collect { height ->
        // create a string representing the row, '#' for tower material and ' ' for air
        // use .trim() to remove spaces at beginning and end and then count remaining spaces
        towers.collect({ it >= height ? "#" : " " }).join("").trim().count(" ")
    }.sum()
}

tasks = [
    [1, 5, 3, 7, 2],
    [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5],
    [5, 6, 7, 8],
    [8, 7, 7, 6],
    [6, 7, 10, 7, 6]
]

tasks.each {
    println "$it => total water: ${waterBetweenTowers it}"
}
