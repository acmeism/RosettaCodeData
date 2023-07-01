var selfDesc = Fn.new { |n|
    var ns = "%(n)"
    var nc = ns.count
    var count = List.filled(nc, 0)
    var sum = 0
    while (n > 0) {
        var d = n % 10
        if (d >= nc) return false  // can't have a digit >= number of digits
        sum = sum + d
        if (sum > nc) return false
        count[d] = count[d] + 1
        n = (n/10).floor
    }
    // to be self-describing sum of digits must equal number of digits
    if (sum != nc) return false
    return ns == count.join() // there must always be at least one zero
}

var start = System.clock
System.print("The self-describing numbers are:")
var i = 10   // self-describing number must end in 0
var pw = 10  // power of 10
var fd = 1   // first digit
var sd = 1   // second digit
var dg = 2   // number of digits
var mx = 11  // maximum for current batch
var lim = 9.1 * 1e9 + 1 // sum of digits can't be more than 10
while (i < lim) {
    if (selfDesc.call(i)) {
        var secs = ((System.clock - start) * 10).round / 10
        System.print("%(i) (in %(secs) secs)")
    }
    i = i + 10
    if (i > mx) {
        fd = fd + 1
        sd = sd - 1
        if (sd >= 0) {
            i = fd * pw
        } else {
            pw = pw * 10
            dg = dg + 1
            i = pw
            fd = 1
            sd = dg - 1
        }
        mx = i + sd*pw/10
    }
}
var osecs = ((System.clock - start) * 10).round / 10
System.print("\nTook %(osecs) secs overall")
