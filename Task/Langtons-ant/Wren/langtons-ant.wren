var width  = 75
var height = 52
var maxSteps = 12000

var up    = 0
var right = 1
var down  = 2
var left  = 3
var direction = [up, right, down, left]

var white = 0
var black = 1

var x = (width/2).floor
var y = (height/2).floor
var m = List.filled(height, null)
for (i in 0...height) m[i] = List.filled(width, 0)
var dir = up
var i = 0
while (i < maxSteps && 0 <= x && x < width && 0 <= y && y < height) {
    var turn = (m[y][x] == black)
    var index = (dir + (turn ? 1 : -1)) & 3
    dir = direction[index]
    m[y][x] = (m[y][x] == black) ? white : black
    if (dir == up) {
        y = y - 1
    } else if (dir == right) {
        x = x - 1
    } else if (dir == down) {
        y = y + 1
    } else {
        x = x + 1
    }
    i = i + 1
}
for (j in 0...height) {
    for (k in 0...width) System.write((m[j][k] == white) ? "." : "#")
    System.print()
}
