import "/math" for Math, Nums
import "/fmt" for Fmt

var waterCollected = Fn.new { |tower|
    var n = tower.count
    var highLeft = [0] + (1...n).map { |i| Nums.max(tower[0...i]) }.toList
    var highRight = (1...n).map { |i| Nums.max(tower[i...n]) }.toList + [0]
    var t = (0...n).map { |i| Math.max(Math.min(highLeft[i], highRight[i]) - tower[i], 0) }
    return Nums.sum(t)
}

var towers = [
    [1, 5, 3, 7, 2],
    [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5],
    [5, 6, 7, 8],
    [8, 7, 7, 6],
    [6, 7, 10, 7, 6]
]
for (tower in towers) Fmt.print("$2d from $n", waterCollected.call(tower), tower)
