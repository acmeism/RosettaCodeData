let array = [[2, 12, 10, 4], [18, 11, 20, 2]]

loop: for row in array {
    for element in row {
        println(" \(element)")
        if element == 20 { break loop }
    }
}
print("done")
