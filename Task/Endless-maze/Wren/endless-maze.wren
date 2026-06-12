import "random" for Random
import "io" for Stdin, Stdout

var xp = 127
var yp = 127
var a  = 0
var na = 0
var x = []
var y = []
var e = []
var r = Random.new()
var f = r.int(4)
var d
var entry

while (true) {
    a = na
    for (n in 0...na) {
        if (x[n] == xp && y[n] == yp) {
            a = n
            break
        }
    }
    if (a == na) {
        na = na + 1
        x.add(xp)
        y.add(yp)
        for (n in 0..3) e.add(r.int(2) == 0 ? false : true)
        for (n in 0...na) {
            if (x[n] == x[a] + 1 && y[n]==y[a]) {
                e[4 * a    ] = e[4 * n + 2]
            } else if (x[n] == x[a] && y[n] == y[a] + 1) {
                e[4 * a + 1] = e[4 * n + 3]
            } else if (x[n] == x[a] - 1 && y[n] == y[a]) {
                e[4 * a + 2] = e[4 * n]
            } else if (x[n] == x[a] && y[n] == y[a] - 1) {
                e[4 * a + 3] = e[4 * n + 1]
            }
        }
    }
    System.write("Paths:")
    if (e[4 * a + (f    ) % 4]) System.write(" ahead")
    if (e[4 * a + (f + 1) % 4]) System.write(" right")
    if (e[4 * a + (f + 2) % 4]) System.write(" back")
    if (e[4 * a + (f + 3) % 4]) System.write(" left")
    System.print()

    d = -1
    while (d < 0) {
        System.write("> ")
        Stdout.flush()
        entry = Stdin.readLine().trim()
        if (entry == "a" || entry == "ahead") {
             d = f % 4
        } else if (entry == "r" || entry == "right") {
             d = (f + 1) % 4
        } else if (entry == "b" || entry == "back") {
             d = (f + 2) % 4
        } else if (entry == "l" || entry == "left") {
             d = (f + 3) % 4
        } else if (entry == "q" || entry == "quit") {
             return
        } else {
             System.print("Invalid")
             continue
        }
    }

    if (d == 0) {
        if (e[4 * a]) {
            xp = xp + 1
            f = d
        } else {
            d = -1
        }
    } else if (d == 1) {
        if (e[4 * a + 1]) {
            yp = yp + 1
            f = d
        } else {
            d = -1
        }
    } else if (d == 2) {
        if (e[4 * a + 2]) {
            xp = xp - 1
            f = d
        } else {
            d = -1
        }
    } else if (d == 3) {
        if (e[4 * a + 3]) {
            yp = yp - 1
            f = d
        } else {
            d = -1
        }
    }
    if (d < 0) System.print("No path")
}
