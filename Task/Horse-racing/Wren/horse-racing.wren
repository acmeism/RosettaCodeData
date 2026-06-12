import "./fmt" for Fmt

// ratings on past form, assuming a rating of 100 for horse A
var a = 100
var b = a - 8 - 2 * 2    // carried 8 lbs less, finished 2 lengths behind
var c = a + 4 - 2 * 3.5
var d = a - 4 - 10 * 0.4 // based on relative weight and time
var e = d + 7 - 2 * 1
var f = d + 11 - 2 * (4 - 2)
var g = a - 10  + 10 * 0.2
var h = g + 6 - 2 * 1.5
var i = g + 15 - 2 * 2

// adjustments to ratings for current race
b = b + 4
c = c - 4
h = h + 3
var j = a - 3 + 10 * 0.2

// filly's allowance to give weight adjusted weighting
b = b + 3
d = d + 3
i = i + 3
j = j + 3

// create map of horse to its weight adjusted rating and whether colt
var m = {
    "A": [a, true],
    "B": [b, false],
    "C": [c, true],
    "D": [d, false],
    "E": [e, true],
    "F": [f, true],
    "G": [g, true],
    "H": [h, true],
    "I": [i, false],
    "J": [j, false]
}
// convert to list of {key, value} map entries
var l = m.toList

// sort in descending order of rating
l.sort{ |i, j| i.value[0] >= j.value[0] }

// show expected result of race
System.print("Race 4\n")
System.print("Pos Horse  Weight  Dist  Sex")
var pos = ""
for (x in 0...l.count) {
    var wt = l[x].value[1] ? "9.00" : "8.11"
    var dist = 0
    if (x > 0) dist = (l[x-1].value[0] - l[x].value[0]) * 0.5
    pos = (x == 0 || dist > 0) ? (x+1).toString : (!pos.endsWith("=") ? x.toString + "=" : pos)
    var sx = l[x].value[1] ? "colt" : "filly"
    Fmt.print("$-2s  $s      $s    $3.1f   $s", pos, l[x].key, wt, dist, sx)
}

// weight adjusted rating of winner
var wr = l[0].value[0]

// expected time of winner (relative to A's time in Race 1)
var t = 96 - (wr - 100) / 10
var min = (t/60).floor
var sec = t % 60
System.print("\nTime %(min) minute %(sec) seconds")
