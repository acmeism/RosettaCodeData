var s = [1, 2, 2, 3, 4, 4, 5]

// There is no output as 'prev' is created anew each time
// around the loop and set implicitly to null.
for (i in 0...s.count) {
    var curr = s[i]
    var prev
    if (i > 0 && curr == prev) System.print(i)
    prev = curr
}

// Now 'prev' is created only once and reassigned
// each time around the loop producing the desired output.
var prev
for (i in 0...s.count) {
    var curr = s[i]
    if (i > 0 && curr == prev) System.print(i)
    prev = curr
}
