import "./sort" for Sort

// Using a map - order of distinct items is undefined.
var removeDuplicates1 = Fn.new { |a|
    if (a.count <= 1) return a
    var m = {}
    for (e in a) m[e] = true
    return m.keys.toList
}

// Sort elements and remove consecutive duplicates.
var removeDuplicates2 = Fn.new { |a|
    if (a.count <= 1) return a
    Sort.insertion(a)
    for (i in a.count-1..1) {
        if (a[i] == a[i-1]) a.removeAt(i)
    }
    return a
}

// Iterate through list and for each element check if it occurs later in the list.
// If it does, discard it.
var removeDuplicates3 = Fn.new { |a|
    if (a.count <= 1) return a
    var i = 0
    while (i < a.count-1) {
        var j = i + 1
        while(j < a.count) {
            if (a[i] == a[j]) {
                a.removeAt(j)
            } else {
                j = j + 1
            }
        }
        i = i + 1
    }
    return a
}

var a = [1,2,3,4,1,2,3,5,1,2,3,4,5]
System.print("Original: %(a)")
System.print("Method 1: %(removeDuplicates1.call(a.toList))") // copy original each time
System.print("Method 2: %(removeDuplicates2.call(a.toList))")
System.print("Method 3: %(removeDuplicates3.call(a.toList))")
