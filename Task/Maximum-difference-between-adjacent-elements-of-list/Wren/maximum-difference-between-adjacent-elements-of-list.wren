var list = [1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8,6, 2, 9, 11, 10, 3]
var maxDiff = -1
var maxPairs = []
for (i in 1...list.count) {
    var diff = (list[i-1] - list[i]).abs
    if (diff > maxDiff) {
        maxDiff = diff
        maxPairs = [[list[i-1], list[i]]]
    } else if (diff == maxDiff) {
        maxPairs.add([list[i-1], list[i]])
    }
}
System.print("The maximum difference between adjacent pairs of the list is: %(maxDiff)")
System.print("The pairs with this difference are: %(maxPairs)")
