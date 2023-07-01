for each (var needle in needles) {
    var idx = haystack.indexOf(needle);
    if (idx == -1)
        throw needle + " does not appear in the haystack"
    else
        print(needle + " appears at index " + idx + " in the haystack");
}

// extra credit

for each (var elem in haystack) {
    var first_idx = haystack.indexOf(elem);
    var last_idx  = haystack.lastIndexOf(elem);
    if (last_idx > first_idx) {
        print(elem + " last appears at index " + last_idx + " in the haystack");
        break
    }
}
