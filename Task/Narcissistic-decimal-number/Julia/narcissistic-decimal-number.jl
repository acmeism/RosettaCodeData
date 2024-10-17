using Printf  # for Julia version 1.0+

function isnarcissist(n, b=10)
    -1 < n || return false
    d = digits(n, base=b)
    m = length(d)
    n == mapreduce((x)->x^m, +, d)
end

function findnarcissist(verbose=false)
    goal = 25
    ncnt = 0
    verbose && println("Finding the first ", goal, " Narcissistic numbers:")
    for i in 0:typemax(1)
        isnarcissist(i) || continue
        ncnt += 1
        verbose && println(@sprintf "    %2d %7d" ncnt i)
        ncnt < goal || break
    end
end

findnarcissist()
@time findnarcissist(true)
