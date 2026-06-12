import "./set" for Set

var ulam = Fn.new() { |n|
    var ulams = [1, 2]
    var set = Set.new(ulams)
    var i = 3
    while (true) {
        var count = 0
        for (j in 0...ulams.count) {
            if (set.contains(i - ulams[j]) && ulams[j] != (i - ulams[j])) {
                count = count + 1
                if (count > 2) break
            }
        }
        if (count == 2) {
            ulams.add(i)
            set.add(i)
            if (ulams.count == n) break
        }
        i = i + 1
    }
    return ulams[-1]
}

var n = 1
while (true) {
    n = n * 10
    System.print("The %(n)th Ulam number is %(ulam.call(n))")
    if (n == 10000) break
}
