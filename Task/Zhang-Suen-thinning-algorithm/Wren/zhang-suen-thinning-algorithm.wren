class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }
    x { _x }
    y { _y }
}

 var image = [
    "                                                          ",
    " #################                   #############        ",
    " ##################               ################        ",
    " ###################            ##################        ",
    " ########     #######          ###################        ",
    "   ######     #######         #######       ######        ",
    "   ######     #######        #######                      ",
    "   #################         #######                      ",
    "   ################          #######                      ",
    "   #################         #######                      ",
    "   ######     #######        #######                      ",
    "   ######     #######        #######                      ",
    "   ######     #######         #######       ######        ",
    " ########     #######          ###################        ",
    " ########     ####### ######    ################## ###### ",
    " ########     ####### ######      ################ ###### ",
    " ########     ####### ######         ############# ###### ",
    "                                                          "
]

var nbrs = [
    [ 0, -1], [ 1, -1], [ 1,  0],
    [ 1,  1], [ 0,  1], [-1,  1],
    [-1,  0], [-1, -1], [ 0, -1]
]

var nbrGroups = [
   [ [0, 2, 4], [2, 4, 6] ],
   [ [0, 2, 6], [0, 4, 6] ]
]

var toWhite = []
var grid = List.filled(image.count, null)
for (i in 0...grid.count) grid[i] = image[i].toList

var numNeighbors = Fn.new { |r, c|
    var count = 0
    for (i in 0...nbrs.count - 1) {
        if (grid[r + nbrs[i][1]][c + nbrs[i][0]] == "#") count = count + 1
    }
    return count
}

var numTransitions = Fn.new { |r, c|
    var count = 0
    for (i in 0...nbrs.count - 1) {
        if (grid[r + nbrs[i][1]][c + nbrs[i][0]] == " ") {
            if (grid[r + nbrs[i + 1][1]][c + nbrs[i + 1][0]] == "#") count = count + 1
        }
    }
    return count
}

var atLeastOneIsWhite = Fn.new { |r, c, step|
    var count = 0
    var group = nbrGroups[step]
    for (i in 0..1) {
        for (j in 0...group[i].count) {
            var nbr = nbrs[group[i][j]]
            if (grid[r + nbr[1]][c + nbr[0]] == " ") {
                count = count + 1
                break
            }
        }
    }
    return count > 1
}

var thinImage = Fn.new {
    var firstStep = false
    var hasChanged
    while (true) {
        hasChanged = false
        firstStep = !firstStep
        for (r in 1...grid.count - 1) {
            for (c in 1...grid[0].count - 1) {
                if (grid[r][c] == "#") {
                    var nn = numNeighbors.call(r, c)
                    if ((2..6).contains(nn)) {
                        if (numTransitions.call(r, c) == 1) {
                            var step = firstStep ? 0 : 1
                            if (atLeastOneIsWhite.call(r, c, step)) {
                                toWhite.add(Point.new(c, r))
                                hasChanged = true
                            }
                        }
                    }
                }
            }
        }
        for (p in toWhite) grid[p.y][p.x] = " "
        toWhite.clear()
        if (!firstStep && !hasChanged) break
    }
    for (row in grid) System.print(row.join())
}

thinImage.call()
