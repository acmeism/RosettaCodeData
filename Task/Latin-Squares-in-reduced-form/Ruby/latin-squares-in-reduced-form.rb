def printSquare(a)
    for row in a
        print row, "\n"
    end
    print "\n"
end

def dList(n, start)
    start = start - 1 # use 0 based indexing
    a = Array.new(n) {|i| i}
    a[0], a[start] = a[start], a[0]
    a[1..] = a[1..].sort
    first = a[1]

    r = []
    recurse = lambda {|last|
        if last == first then
            # bottom of recursion, reached once for each permutation
            # test if permutation is deranged
            a[1..].each_with_index {|v, j|
                if j + 1 == v then
                    return # no, ignore it
                end
            }
            # yes, save a copy with 1 based indexing
            b = a.map { |i| i + 1 }
            r << b
            return
        end

        i = last
        while i >= 1 do
            a[i], a[last] = a[last], a[i]
            recurse.call(last - 1)
            a[i], a[last] = a[last], a[i]
            i = i - 1
        end
    }

    recurse.call(n - 1)
    return r
end

def reducedLatinSquares(n, echo)
    if n <= 0 then
        if echo then
            print "[]\n\n"
        end
        return 0
    end
    if n == 1 then
        if echo then
            print "[1]\n\n"
        end
        return 1
    end

    rlatin = Array.new(n) { Array.new(n, Float::NAN)}

    # first row
    for j in 0 .. n - 1
        rlatin[0][j] = j + 1
    end

    count = 0
    recurse = lambda {|i|
        rows = dList(n, i)

        for r in 0 .. rows.length - 1
            rlatin[i - 1] = rows[r].dup
            catch (:outer) do
                for k in 0 .. i - 2
                    for j in 1 .. n - 1
                        if rlatin[k][j] == rlatin[i - 1][j] then
                            if r < rows.length - 1 then
                                throw :outer
                            end
                            if i > 2 then
                                return
                            end
                        end
                    end
                end
                if i < n then
                    recurse.call(i + 1)
                else
                    count = count + 1
                    if echo then
                        printSquare(rlatin)
                    end
                end
            end
        end
    }

    # remaining rows
    recurse.call(2)
    return count
end

def factorial(n)
    if n == 0 then
        return 1
    end
    prod = 1
    for i in 2 .. n
        prod = prod * i
    end
    return prod
end

print "The four reduced latin squares of order 4 are:\n"
reducedLatinSquares(4, true)

print "The size of the set of reduced latin squares for the following orders\n"
print "and hence the total number of latin squares of these orders are:\n"
for n in 1 .. 6
    size = reducedLatinSquares(n, false)
    f = factorial(n - 1)
    f = f * f * n * size
    print "Order %d Size %-4d x %d! x %d! => Total %d\n" % [n, size, n, n - 1, f]
end
