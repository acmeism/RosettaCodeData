var s = 1, c = 1, cube = 1, n = 0
while n < 30 {
    let square = s * s
    while cube < square {
        c += 1
        cube = c * c * c
    }
    if cube == square {
        print("\(square) is a square and a cube.")
    } else {
        print(square)
        n += 1
    }
    s += 1
}
