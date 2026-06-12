var specialMatrix = Fn.new { |n|
    for (i in 0...n) {
        for (j in 0...n) {
            System.write((i == j || i + j == n - 1) ? "1 " : "0 ")
        }
        System.print()
    }
}

specialMatrix.call(6)  // even n
System.print()
specialMatrix.call(7)  // odd n
