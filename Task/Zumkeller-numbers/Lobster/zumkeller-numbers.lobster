import std

// Derived from Julia and Python versions

def get_divisors(n: int) -> [int]:
    var i = 2
    let d = [1, n]
    let limit = sqrt(n)
    while i <= limit:
        if n % i == 0:
            let j = n / i
            push(d,i)
            if i != j:
                push(d,j)
        i += 1
    return d

def isPartSum(divs: [int], sum: int) -> bool:
    if sum == 0:
        return true
    let len = length(divs)
    if len == 0:
        return false
    let last = pop(divs)
    if last > sum:
        return isPartSum(divs, sum)
    return isPartSum(copy(divs), sum) or isPartSum(divs, sum-last)

def isZumkeller(n: int) -> bool:
    let divs = get_divisors(n)
    let sum = fold(divs, 0): _a+_b
    if sum % 2 == 1:
        // if sum is odd can't be split into two partitions with equal sums
        return false
    if n % 2 == 1:
        // if n is odd use 'abundant odd number' optimization
        let abundance = sum - 2 * n
        return abundance > 0 and abundance % 2 == 0
    return isPartSum(divs, sum/2)

def printZumkellers(q: int, oddonly: bool):
    var nprinted = 0
    var res = ""
    for(100000) n:
        if (!oddonly or n % 2 != 0):
            if isZumkeller(n):
                let s = string(n)
                let z = length(s)
                res = concat_string([res, repeat_string(" ",8-z), s], "")
                nprinted += 1
                if nprinted % 10 == 0 or nprinted >= q:
                    print res
                    res = ""
                    if nprinted >= q:
                        return

print "220 Zumkeller numbers:"
printZumkellers(220, false)
print "\n\n40 odd Zumkeller numbers:"
printZumkellers(40, true)
