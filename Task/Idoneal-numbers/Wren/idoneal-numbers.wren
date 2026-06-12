import "./fmt" for Fmt

var isIdoneal = Fn.new { |n|
    for (a in 1...n) {
        for (b in a+1...n) {
            if (a*b + a + b > n) break
            for (c in b+1...n) {
                var sum = a*b + b*c + a*c
                if (sum == n) return false
                if (sum > n) break
            }
        }
    }
    return true
}

var idoneals = []
for (n in 1..1850) if (isIdoneal.call(n)) idoneals.add(n)
Fmt.tprint("$4d", idoneals, 13)
