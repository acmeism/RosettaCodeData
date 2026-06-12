var lantern // recursive function
lantern = Fn.new { |n, a|
    var count = 0
    for (i in 0...n) {
        if (a[i] != 0) {
            a[i] = a[i] - 1
            count = count + lantern.call(n, a)
            a[i] = a[i] + 1
        }
    }
    if (count == 0) count = 1
    return count
}

System.print("Number of permutations for n (<= 5) groups and lanterns per group [1..n]:")
var n = 0
for (i in 1..5) {
   var a = (1..i).toList
   n = n + 1
   System.print("%(a) => %(lantern.call(n, a))")
}
