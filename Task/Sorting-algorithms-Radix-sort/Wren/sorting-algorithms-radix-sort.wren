// counting sort of 'a' according to the digit represented by 'exp'
var countSort = Fn.new { |a, exp|
    var n = a.count
    var output = [0] * n
    var count  = [0] * 10
    for (i in 0...n) {
        var t = (a[i]/exp).truncate % 10
        count[t] = count[t] + 1
    }
    for (i in 1..9) count[i] = count[i] + count[i-1]
    for (i in n-1..0) {
        var t = (a[i]/exp).truncate % 10
        output[count[t] - 1] = a[i]
        count[t] = count[t] - 1
    }
    for (i in 0...n) a[i] = output[i]
}

// sorts 'a' in place
var radixSort = Fn.new { |a|
    // check for negative elements
    var min = a.reduce { |m, i| (i < m) ? i : m }
    // if there are any, increase all elements by -min
    if (min < 0) (0...a.count).each { |i| a[i] = a[i] - min }
    // now get the maximum to know number of digits
    var max = a.reduce { |m, i| (i > m) ? i : m }
    // do counting sort for each digit
    var exp = 1
    while ((max/exp).truncate > 0) {
        countSort.call(a, exp)
        exp = exp * 10
    }
    // if there were negative elements, reduce all elements by -min
    if (min < 0) (0...a.count).each { |i| a[i] = a[i] + min }
}

var aa =  [[4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [170, 45, 75, 90, 2, 24, -802, -66]]
for (a in aa) {
    System.print("Unsorted: %(a)")
    radixSort.call(a)
    System.print("Sorted  : %(a)\n")
}
