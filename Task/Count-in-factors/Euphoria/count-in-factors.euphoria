function factorize(integer n)
    sequence result
    integer k
    if n = 1 then
        return {1}
    else
        k = 2
        result = {}
        while n > 1 do
            while remainder(n, k) = 0 do
                result &= k
                n /= k
            end while
            k += 1
        end while
        return result
    end if
end function

sequence factors
for i = 1 to 22 do
    printf(1, "%d: ", i)
    factors = factorize(i)
    for j = 1 to length(factors)-1 do
        printf(1, "%d * ", factors[j])
    end for
    printf(1, "%d\n", factors[$])
end for
