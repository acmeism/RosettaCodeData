import "/sort" for Sort

// sorts values in place, leaves indices unsorted
var sortDisjoint = Fn.new { |values, indices|
    var sublist = []
    for (ix in indices) sublist.add(values[ix])
    Sort.quick(sublist)
    var i = 0
    var indices2 = Sort.merge(indices)
    for (ix in indices2) {
        values[ix] = sublist[i]
        i = i + 1
    }
}

var values  = [7, 6, 5, 4, 3, 2, 1, 0]
var indices = [6, 1, 7]
System.print("Initial: %(values)")
sortDisjoint.call(values, indices)
System.print("Sorted : %(values)")
