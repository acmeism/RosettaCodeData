import "random" for Random
import "./fmt" for Fmt

var countdown // recursive function
countdown = Fn.new { |target, numbers|
    if (numbers.count == 1) return false
    for (n0 in numbers) {
        var nums1 = numbers.toList
        nums1.remove(n0)
        for (n1 in nums1) {
            var nums2 = nums1.toList
            nums2.remove(n1)
            if (n1 >= n0) {
                var res = n1 + n0
                var numsNew = nums2.toList
                numsNew.add(res)
                if (res == target || countdown.call(target, numsNew)) {
                    Fmt.print("$d = $d + $d", res, n1, n0)
                    return true
                }
                if (n0 != 1) {
                    res = n1 * n0
                    numsNew = nums2.toList
                    numsNew.add(res)
                    if (res == target || countdown.call(target, numsNew)) {
                        Fmt.print("$d = $d * $d", res, n1, n0)
                        return true
                    }
                }
                if (n1 != n0) {
                    res = n1 - n0
                    numsNew = nums2.toList
                    numsNew.add(res)
                    if (res == target || countdown.call(target, numsNew)) {
                        Fmt.print("$d = $d - $d", res, n1, n0)
                        return true
                    }
                }
                if (n0 != 1 && n1 % n0 == 0) {
                    res = (n1/n0).truncate
                    numsNew = nums2.toList
                    numsNew.add(res)
                    if (res == target || countdown.call(target, numsNew)) {
                        Fmt.print("$d = $d / $d", res, n1, n0)
                        return true
                    }
                }
            }
        }
    }
    return false
}

var allNumbers = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100]
var rand = Random.new()
var numbersList = [
    [3, 6, 25, 50, 75, 100],
    [100, 75, 50, 25, 6, 3], // see if there's much difference if we reverse the first example
    [8, 4, 4, 6, 8, 9],
    rand.sample(allNumbers, 6)
]
var targetList = [952, 952, 594, rand.int(101, 1000)]
for (i in 0...numbersList.count) {
    System.print("Using : %(numbersList[i])")
    System.print("Target: %(targetList[i])")
    var start = System.clock
    var done = countdown.call(targetList[i], numbersList[i])
    System.print("Took %(((System.clock - start) * 1000).round) ms")
    if (!done) System.print("No exact solution found")
    System.print()
}
