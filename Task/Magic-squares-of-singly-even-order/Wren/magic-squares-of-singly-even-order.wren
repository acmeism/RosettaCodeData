import "/fmt" for Fmt

var magicSquareOdd = Fn.new { |n|
    if (n < 3 || n%2 == 0) Fiber.abort("Base must be odd and > 2")
    var value = 1
    var gridSize = n * n
    var c = (n/2).floor
    var r = 0
    var result = List.filled(n, null)
    for (i in 0...n) result[i] = List.filled(n, 0)
    while (value <= gridSize) {
        result[r][c] = value
        if (r == 0) {
            if (c == n - 1) {
                r = r + 1
            } else {
                r = n - 1
                c = c + 1
            }
        } else if (c == n - 1) {
            r = r - 1
            c = 0
        } else if (result[r - 1][c + 1] == 0) {
            r = r - 1
            c = c + 1
        } else {
            r = r + 1
        }
        value = value + 1
    }
    return result
}

var magicSquareSinglyEven = Fn.new { |n|
    if (n < 6 || (n - 2) % 4 != 0) {
        Fiber.abort("Base must be a positive multiple of 4 plus 2")
    }
    var size = n * n
    var halfN = n / 2
    var subSquareSize = size / 4
    var subSquare = magicSquareOdd.call(halfN)
    var quadrantFactors = [0, 2, 3, 1]
    var result = List.filled(n, null)
    for (i in 0...n) result[i] = List.filled(n, 0)
    for (r in 0...n) {
        for (c in 0...n) {
            var quadrant = (r/halfN).floor * 2 + (c/halfN).floor
            result[r][c] = subSquare[r % halfN][c % halfN]
            result[r][c] = result[r][c] + quadrantFactors[quadrant] * subSquareSize
        }
    }
    var nColsLeft = (halfN/2).floor
    var nColsRight = nColsLeft - 1
    for (r in 0...halfN) {
        for (c in 0...n) {
            if (c < nColsLeft || c >= n - nColsRight || (c == nColsLeft && r == nColsLeft)) {
                if (c != 0 || r != nColsLeft) {
                    var tmp = result[r][c]
                    result[r][c] = result[r + halfN][c]
                    result[r + halfN][c] = tmp
                }
            }
        }
    }
    return result
}

var n = 6
for (ia in magicSquareSinglyEven.call(n)) {
    for (i in ia) Fmt.write("$2d  ", i)
    System.print()
}
System.print("\nMagic constant %((n * n + 1) * n / 2)")
