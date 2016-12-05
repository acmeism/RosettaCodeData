var doors = [true] * 100
for (i in 1..100) {
    var j = i
    while(j < 100) {
        doors[j] = !doors[j]
        j = j + i + 1
    }
}

for (i in 0...100) {
    if (doors[i]) System.print(i + 1)
}
