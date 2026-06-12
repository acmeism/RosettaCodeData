? "working..."

prod = 1
bestProd = 0
// maximum 3 digit number
max = 999
// both factors must be >100 for a 6 digit product
limitStart = 101
// one factor must be divisible by 11
limitEnd = 11 * floor(max / 11)
second = limitStart
iters = 0

// loop from hi to low to find the best result in the fewest steps
for n = limitEnd to limitStart step -11
    // with n falling, the lower limit of m can rise with
    // the best-found-so-far second number. Doing this
    // lowers the iteration count by a lot.
    for m = max to second step -2
        prod = n * m
        if isPal(prod)
            iters++
            // exit when the product stops increasing
            if bestProd > prod
                exit
            ok
            // maintain the best-found-so-far result
            first = n
            second = m
            bestProd = prod
        ok
    next
next

put "The largest palindrome is: "
? "" + bestProd + " = " + first + " * " + second
? "Found in " + iters + " iterations"
put "done..."

func isPal n
    x = string(n)
    l = len(x) + 1
    i = 0
    while i < l
        if x[i++] != x[l--]
            return false
        ok
    end
    return true
