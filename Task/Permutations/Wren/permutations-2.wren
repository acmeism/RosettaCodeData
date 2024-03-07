import "./math" for Int

var input = [1, 2, 3]
var perms = [input]
var a = input.toList
var n = a.count - 1
for (c in 1...Int.factorial(n+1)) {
    var i = n - 1
    var j = n
    while (a[i] > a[i+1]) i = i - 1
    while (a[j] < a[i])   j = j - 1
    var t = a[i]
    a[i] = a[j]
    a[j] = t
    j = n
    i = i + 1
    while (i < j) {
        t = a[i]
        a[i] = a[j]
        a[j] = t
        i = i + 1
        j = j - 1
    }
    perms.add(a.toList)
}
System.print("There are %(perms.count) permutations of %(input), namely:\n")
perms.each { |perm| System.print(perm) }
