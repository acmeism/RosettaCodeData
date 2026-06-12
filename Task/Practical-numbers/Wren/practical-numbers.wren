import "./math" for Int, Nums

var powerset // recursive
powerset = Fn.new { |set|
    if (set.count == 0) return [[]]
    var head = set[0]
    var tail = set[1..-1]
    return powerset.call(tail) + powerset.call(tail).map { |s| [head] + s }
}

var isPractical = Fn.new { |n|
   if (n == 1) return true
   var divs = Int.properDivisors(n)
   var subsets = powerset.call(divs)
   var found = List.filled(n, false)
   var count = 0
   for (subset in subsets) {
       var sum = Nums.sum(subset)
       if (sum > 0 && sum < n && !found[sum]) {
          found[sum] = true
          count = count + 1
          if (count == n - 1) return true
       }
   }
   return false
}

System.print("In the range 1..333, there are:")
var practical = []
for (i in 1..333) {
    if (isPractical.call(i)) {
        practical.add(i)
    }
}
System.print("  %(practical.count) practical numbers")
System.print("  The first ten are %(practical[0..9])")
System.print("  The final ten are %(practical[-10..-1])")
System.print("\n666 is practical: %(isPractical.call(666))")
