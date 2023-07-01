// Print odd numbers under 20.
for (i in 1..10) {
    var j = 2*i - 1
    System.write("%(j) ")
}

System.print("\n")

// Do the same using a 'while' loop.
var k = 1
while (k < 20) {
    System.write("%(k) ")
    k = k + 2
}
System.print()
