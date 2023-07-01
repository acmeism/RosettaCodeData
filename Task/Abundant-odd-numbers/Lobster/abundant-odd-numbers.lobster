// Note that the following function is for odd numbers only
// Use "for (unsigned i = 2; i*i <= n; i++)" for even and odd numbers

def sum_proper_divisors_of_odd(n: int) -> int:
    var sum = 1
    var i = 3
    let limit = sqrt(n) + 1
    while i < limit:
        if n % i == 0:
            sum += i
            let j = n / i
            if i != j:
                sum += j
        i += 2
    return sum

def abundant_odd_numbers():
    var n = 1
    var c = 0
    print "index: number proper_sum"
    while c < 25:
        let s = sum_proper_divisors_of_odd(n)
        if n < s:
            c += 1
            print concat_string([string(c), ": ", string(n), ", ", string(s)], "")
        n += 2
    var s = 1
    while c < 1000:
        s = sum_proper_divisors_of_odd(n)
        if n < s:
            c += 1
        n += 2
    print concat_string(["1000: ", string(n), ", ", string(s)], "")
    n =  999999999
    while n >= s:
        n += 2
        s = sum_proper_divisors_of_odd(n)
    print concat_string(["The first abundant odd number above one billion is: ", string(n), ", ", string(s)], "")


abundant_odd_numbers()
