// version 1.1.2

class Point(val x: Int, val y: Int)

val image = arrayOf(
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
)

val nbrs = arrayOf(
    intArrayOf( 0, -1), intArrayOf( 1, -1), intArrayOf( 1,  0),
    intArrayOf( 1,  1), intArrayOf( 0,  1), intArrayOf(-1,  1),
    intArrayOf(-1,  0), intArrayOf(-1, -1), intArrayOf( 0, -1)
)

val nbrGroups = arrayOf(
    arrayOf(intArrayOf(0, 2, 4), intArrayOf(2, 4, 6)),
    arrayOf(intArrayOf(0, 2, 6), intArrayOf(0, 4, 6))
)

val toWhite = mutableListOf<Point>()
val grid = Array(image.size) { image[it].toCharArray() }

fun thinImage() {
    var firstStep = false
    var hasChanged: Boolean
    do {
        hasChanged = false
        firstStep = !firstStep
        for (r in 1 until grid.size - 1) {
            for (c in 1 until grid[0].size - 1) {
                if (grid[r][c] != '#') continue
                val nn = numNeighbors(r, c)
                if (nn !in 2..6) continue
                if (numTransitions(r, c) != 1) continue
                val step = if (firstStep) 0 else 1
                if (!atLeastOneIsWhite(r, c, step)) continue
                toWhite.add(Point(c, r))
                hasChanged = true
            }
        }
        for (p in toWhite) grid[p.y][p.x] = ' '
        toWhite.clear()
    }
    while (firstStep || hasChanged)
    for (row in grid) println(row)
}

fun numNeighbors(r: Int, c: Int): Int {
    var count = 0
    for (i in 0 until nbrs.size - 1) {
        if (grid[r + nbrs[i][1]][c + nbrs[i][0]] == '#') count++
    }
    return count
}

fun numTransitions(r: Int, c: Int): Int {
    var count = 0
    for (i in 0 until nbrs.size - 1) {
        if (grid[r + nbrs[i][1]][c + nbrs[i][0]] == ' ') {
            if (grid[r + nbrs[i + 1][1]][c + nbrs[i + 1][0]] == '#') count++
        }
    }
    return count
}

fun atLeastOneIsWhite(r: Int, c: Int, step: Int): Boolean {
    var count = 0;
    val group = nbrGroups[step]
    for (i in 0..1) {
        for (j in 0 until group[i].size) {
            val nbr = nbrs[group[i][j]]
            if (grid[r + nbr[1]][c + nbr[0]] == ' ') {
                count++
                break
            }
        }
    }
    return count > 1
}

fun main(args: Array<String>) {
    thinImage()
}
