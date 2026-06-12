var mosaicMatrix = Fn.new { |n|
    for (i in 0...n) {
        for (j in 0...n) {
            System.write(((i + j) % 2 == 0) ? "1 " : ". ")
        }
        System.print()
    }
}

mosaicMatrix.call(9)
