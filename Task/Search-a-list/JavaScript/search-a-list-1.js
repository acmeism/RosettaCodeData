var haystack = ['Zig', 'Zag', 'Wally', 'Ronald', 'Bush', 'Krusty', 'Charlie', 'Bush', 'Bozo']
var needles = ['Bush', 'Washington']

for (var i in needles) {
    var found = false;
    for (var j in haystack) {
        if (haystack[j] == needles[i]) {
            found = true;
            break;
        }
    }
    if (found)
        print(needles[i] + " appears at index " + j + " in the haystack");
    else
        throw needles[i] + " does not appear in the haystack"
}
