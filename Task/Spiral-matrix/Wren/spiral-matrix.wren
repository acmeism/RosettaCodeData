import "/fmt" for Conv, Fmt

var n = 5
var top = 0
var left = 0
var bottom = n - 1
var right = n - 1
var sz = n * n
var a = List.filled(sz, 0)
var i = 0
while (left < right) {
    // work right, along top
    var c = left
    while (c <= right) {
        a[top*n+c] = i
        i = i + 1
        c = c + 1
    }
    top = top + 1
    // work down right side
    var r = top
    while (r <= bottom) {
        a[r*n+right] = i
        i = i + 1
        r = r + 1
    }
    right = right - 1
    if (top == bottom) break
    // work left, along bottom
    c = right
    while (c >= left) {
        a[bottom*n+c] = i
        i = i + 1
        c = c - 1
    }
    bottom = bottom - 1
    r = bottom
    // work up left side
    while (r >= top) {
        a[r*n+left] = i
        i = i + 1
        r = r - 1
    }
    left = left + 1
}
// center (last) element
a[top*n+left] = i

// print
var w = Conv.itoa(n*n - 1).count
i = 0
for (e in a) {
    Fmt.write("$*d ", w, e)
    if (i%n == n - 1) System.print()
    i = i + 1
}
