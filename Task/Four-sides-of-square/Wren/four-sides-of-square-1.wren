var hollowMatrix = Fn.new { |n|
    for (i in 0...n) {
        for (j in 0...n) {
            System.write((i == 0 || i == n-1 || j == 0 || j == n-1) ? "1 " : "0 ")
        }
        System.print()
    }
}

hollowMatrix.call(9)
