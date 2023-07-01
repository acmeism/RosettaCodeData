class Sudoku {
    construct new(rows) {
        if (rows.count != 9 || rows.any { |r| r.count != 9 }) {
            Fiber.abort("Grid must be 9 x 9")
        }
        _grid = List.filled(81, null)
        for (i in 0..8) {
            for (j in 0..8 ) _grid[9 * i + j] = rows[i][j]
        }
        _solved = false
    }

    checkValidity_(v, x, y) {
        for (i in 0..8) {
            if (_grid[y * 9 + i] == v || _grid[i * 9 + x] == v) return false
        }
        var startX = (x / 3).floor * 3
        var startY = (y / 3).floor * 3
        for (i in startY...startY + 3) {
            for (j in startX...startX + 3) {
                if (_grid[i * 9 + j] == v) return false
            }
        }
        return true
    }

    placeNumber_(pos) {
        if (_solved) return
        if (pos == 81) {
            _solved = true
            return
        }
        if (_grid[pos].bytes[0] > 48) {
            placeNumber_(pos + 1)
            return
        }
        for (n in 1..9) {
            if (checkValidity_(n.toString, pos % 9, (pos/9).floor)) {
                _grid[pos] = n.toString
                placeNumber_(pos + 1)
                if (_solved) return
                _grid[pos] = "0"
            }
        }
    }

    solve() {
        System.print("Starting grid:\n\n%(this)")
        placeNumber_(0)
        System.print(_solved ? "Solution:\n\n%(this)" : "Unsolvable!")
    }

    toString {
        var sb = ""
        for (i in 0..8) {
            for (j in 0..8) {
                sb = sb + _grid[i * 9 + j] + " "
                if (j == 2 || j == 5) sb = sb + "| "
            }
            sb = sb + "\n"
            if (i == 2 || i == 5) sb = sb + "------+-------+------\n"
        }
        return sb
    }
}

var rows = [
    "850002400",
    "720000009",
    "004000000",
    "000107002",
    "305000900",
    "040000000",
    "000080070",
    "017000000",
    "000036040"
]
Sudoku.new(rows).solve()
