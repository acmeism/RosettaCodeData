import "random" for Random
import "/sort" for Sort

var colors = ["Red", "White", "Blue"]
var colorMap = { "Red": 0, "White": 1, "Blue": 2 }
var colorCmp = Fn.new { |c1, c2| (colorMap[c1] - colorMap[c2]).sign }
var NUM_BALLS = 9
var r = Random.new()
var balls = List.filled(NUM_BALLS, colors[0])

while (true) {
    for (i in 0...NUM_BALLS) balls[i] = colors[r.int(3)]
    if (!Sort.isSorted(balls, colorCmp)) break
}

System.print("Before sorting : %(balls)")
Sort.insertion(balls, colorCmp)
System.print("After sorting  : %(balls)")
