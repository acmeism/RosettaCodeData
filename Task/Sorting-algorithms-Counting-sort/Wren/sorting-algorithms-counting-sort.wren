var countingSort = Fn.new { |a, min, max|
    var count = List.filled(max - min + 1, 0)
    for (n in a) count[n - min] = count[n - min] + 1
    var z = 0
    for (i in min..max) {
        while (count[i - min] > 0) {
            a[z] = i
            z = z + 1
            count[i - min] = count[i - min] - 1
        }
    }
}

var a = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
System.print("Unsorted: %(a)")
var min = a.reduce { |min, i| (i < min) ? i : min }
var max = a.reduce { |max, i| (i > max) ? i : max }
countingSort.call(a, min, max)
System.print("Sorted  : %(a)")
