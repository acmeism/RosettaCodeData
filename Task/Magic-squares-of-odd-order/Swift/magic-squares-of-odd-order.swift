extension String: Error {}

struct Point: CustomStringConvertible {
    var x: Int
    var y: Int

    init(_ _x: Int,
         _ _y: Int) {
        self.x = _x
        self.y = _y
    }

    var description: String {
        return "(\(x), \(y))\n"
    }
}

extension Point: Equatable,Comparable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.y != rhs.y ? lhs.y < rhs.y : lhs.x < rhs.x
    }
}

class MagicSquare: CustomStringConvertible {
    var grid:[Int:Point] = [:]
    var number: Int = 1
    init(base n:Int) {
        grid = [:]
        number = n
    }

    func createOdd() throws -> MagicSquare {
        guard number < 1 || number % 2 != 0 else {
            throw "Must be odd and >= 1, try again"
            return self
        }
        var x = 0
        var y = 0
        let middle = Int(number/2)
        x = middle
        grid[1] = Point(x,y)
        for i in 2 ... number*number {
            let oldXY = Point(x,y)
            x += 1
            y -= 1

            if x >= number {x -= number}
            if y < 0 {y +=  number}

            var tempCoord = Point(x,y)
            if let _ = grid.firstIndex(where: { (k,v) -> Bool in
                v == tempCoord
            })
            {
                x = oldXY.x
                y = oldXY.y + 1
                if y >= number {y -= number}
                tempCoord = Point(x,y)
            }
            grid[i] = tempCoord
        }
        print(self)
        return self
    }

    fileprivate func gridToText(_ result: inout String) {
        let sorted = sortedGrid()
        let sc = sorted.count
        var i = 0
        for c in sorted {
            result += " \(c.key)"
            if c.key < 10 && sc > 10 { result += " "}
            if c.key < 100 && sc > 100 { result += " "}
            if c.key < 1000 && sc > 1000 { result += " "}
            if i%number==(number-1) { result += "\n"}
            i += 1
        }
        result += "\nThe magic number is \(number * (number * number + 1) / 2)"
        result += "\nRows and Columns are "

        result += checkRows() == checkColumns() ? "Equal" : " Not Equal!"
        result += "\nRows and Columns and Diagonals are "
        let allEqual = (checkDiagonals() == checkColumns() && checkDiagonals() == checkRows())
        result += allEqual ? "Equal" : " Not Equal!"
        result += "\n"
    }

    var description: String {
        var result = "base \(number)\n"
        gridToText(&result)
        return result
    }
}

extension MagicSquare {
    private func sortedGrid()->[(key:Int,value:Point)] {
        return grid.sorted(by: {$0.1 < $1.1})
    }

    private func checkRows() -> (Bool, Int?)
    {
        var result = Set<Int>()
        var index = 0
        var rowtotal = 0
        for (cell, _) in sortedGrid()
        {
            rowtotal += cell
            if index%number==(number-1)
            {
                result.insert(rowtotal)
                rowtotal = 0
            }
            index += 1
        }
        return (result.count == 1, result.first ?? nil)
    }

    private func checkColumns() -> (Bool, Int?)
    {
        var result = Set<Int>()
        var sorted = sortedGrid()
        for i in 0 ..< number {
            var rowtotal = 0
            for cell in stride(from: i, to: sorted.count, by: number) {
                rowtotal += sorted[cell].key
            }
            result.insert(rowtotal)
        }
        return (result.count == 1, result.first)
    }

    private func checkDiagonals() -> (Bool, Int?)
    {
        var result = Set<Int>()
        var sorted = sortedGrid()

        var rowtotal = 0
        for cell in stride(from: 0, to: sorted.count, by: number+1) {
            rowtotal += sorted[cell].key
        }
        result.insert(rowtotal)
        rowtotal = 0
        for cell in stride(from: number-1, to: sorted.count-(number-1), by: number-1) {
            rowtotal += sorted[cell].key
        }
        result.insert(rowtotal)

        return (result.count == 1, result.first)
    }
}

try MagicSquare(base: 3).createOdd()
try MagicSquare(base: 5).createOdd()
try MagicSquare(base: 7).createOdd()
