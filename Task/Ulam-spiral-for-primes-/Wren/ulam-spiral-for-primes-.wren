import "/dynamic" for Enum
import "/math" for Int
import "/str" for Char
import "/fmt" for Fmt

var Direction = Enum.create("Direction", ["right", "up", "left", "down"])

class Ulam {
    static generate(n, i, c) {
        if (n <= 1) Fiber.abort ("'n' must be more than 1.")
        var s = List.filled(n, null)
        for (i in 0...n) s[i] = List.filled(n, "")
        var dir = Direction.right
        var y = (n/2).floor
        var x = (n % 2 == 0) ? y - 1 : y  // shift left for even n's
        for (j in i..n * n - 1 + i) {
            s[y][x] = Int.isPrime(j) ? (Char.isDigit(c) ? Fmt.d(4, j) : "  %(c) ") : " ---"
            if (dir == Direction.right) {
                if (x <= n - 1 && s[y - 1][x] == "" && j > i) dir = Direction.up
            } else if (dir == Direction.up) {
                if (s[y][x - 1] == "") dir = Direction.left
            } else if (dir == Direction.left) {
                if (x == 0 || s[y + 1][x] == "") dir = Direction.down
            } else if (dir == Direction.down) {
                if (s[y][x + 1] == "") dir = Direction.right
            }

            if (dir == Direction.right) {
                x = x + 1
            } else if (dir == Direction.up) {
                y = y - 1
            } else if (dir == Direction.left) {
                x = x - 1
            } else if (dir == Direction.down) {
                y = y + 1
            }
        }

        for (row in s) Fmt.print("$s", row)
        System.print()
    }
}

Ulam.generate(9, 1, "0") // with digits
Ulam.generate(9, 1, "*") // with *
