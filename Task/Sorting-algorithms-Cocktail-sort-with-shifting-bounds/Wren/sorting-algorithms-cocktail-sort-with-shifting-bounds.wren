import "./fmt" for Fmt
import "random" for Random

// translation of pseudo-code
var cocktailShakerSort = Fn.new { |a|
    var begin = 0
    var end = a.count - 2
    while (begin <= end) {
        var newBegin = end
        var newEnd = begin
        for (i in begin..end) {
            if (a[i] > a[i+1]) {
                var t = a[i+1]
                a[i+1] = a[i]
                a[i] = t
                newEnd = i
            }
        }
        end = newEnd - 1
        if (end >= begin) {
            for (i in end..begin) {
                if (a[i] > a[i+1]) {
                    var t = a[i+1]
                    a[i+1] = a[i]
                    a[i] = t
                    newBegin = i
                }
            }
        }
        begin = newBegin + 1
    }
}

// from the RC Cocktail sort task (no optimizations)
var cocktailSort = Fn.new { |a|
    var last = a.count - 1
    while (true) {
        var swapped = false
        for (i in 0...last) {
            if (a[i] > a[i+1]) {
                var t = a[i]
                a[i] = a[i+1]
                a[i+1] = t
                swapped = true
            }
        }
        if (!swapped) return
        swapped = false
        if (last >= 1) {
            for (i in last-1..0) {
                if (a[i] > a[i+1]) {
                    var t = a[i]
                    a[i] = a[i+1]
                    a[i+1] = t
                    swapped = true
                }
            }
        }
        if (!swapped) return
    }
}

// First make sure the routines are working correctly.
var a = [21, 4, -9, 62, -7, 107, -62, 4, 0, -170]
System.print("Original array: %(a)")
var b = a.toList // make copy as sorts mutate array in place
cocktailSort.call(a)
System.print("Cocktail sort : %(a)")
cocktailShakerSort.call(b)
System.print("C/Shaker sort : %(b)")

// timing comparison code
var rand = Random.new()
System.print("\nRelative speed of the two sorts")
System.print("  N    x faster (CSS v CS)")
System.print("-----  -------------------")
var runs = 5 // average over 5 runs say
for (n in [1000, 2000, 4000, 8000, 10000, 20000]) {
    var sum = 0
    for (i in 1..runs) {
        // get 'n' random numbers in range [0, 100,000]
        // with every other number being negated
        var nums = List.filled(n, 0)
        for (i in 0...n) {
            var rn = rand.int(100000)
            if (i%2 == 1) rn = -rn
            nums[i] = rn
        }
        // copy the array
        var nums2 = nums.toList

        var start = System.clock
        cocktailSort.call(nums)
        var elapsed = System.clock - start
        var start2 = System.clock
        cocktailShakerSort.call(nums2)
        var elapsed2 = System.clock - start2
        sum = sum + elapsed/elapsed2
    }
    System.print(" %(Fmt.d(2, (n/1000).floor))k      %(Fmt.f(0, sum/runs, 3))")
}
