import "random" for Random

var rand = Random.new()

var printSquare = Fn.new { |latin|
    for (row in latin) System.print(row)
    System.print()
}

var latinSquare = Fn.new { |n|
    if (n <= 0) {
        System.print("[]\n")
        return
    }
    var latin = List.filled(n, null)
    for (i in 0...n) {
        latin[i] = List.filled(n, 0)
        if (i == n - 1) break
        for (j in 0...n) latin[i][j] = j
    }

    // first row
    rand.shuffle(latin[0])

    // middle row(s)
    for (i in 1...n-1) {
        var shuffled = false
        while (!shuffled) {
            rand.shuffle(latin[i])
            var shuffling = false
            for (k in 0...i) {
                for (j in 0...n) {
                    if (latin[k][j] == latin[i][j]) {
                        shuffling = true
                        break
                    }
                }
                if (shuffling) break
            }
            if (!shuffling) shuffled = true
        }
    }

    // last row
    for (j in 0...n) {
        var used = List.filled(n, false)
        for (i in 0...n-1) used[latin[i][j]] = true
        for (k in 0...n) {
            if (!used[k]) {
                latin[n-1][j] = k
                break
            }
        }
    }
    printSquare.call(latin)
}

latinSquare.call(5)
latinSquare.call(5)
latinSquare.call(10) // for good measure
