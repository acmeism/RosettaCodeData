require 'set'

a = [0]
used = Set[0]
used1000 = Set[0]
foundDup = false
n = 1
while n <= 15 or not foundDup or used1000.size < 1001
    nxt = a[n - 1] - n
    if nxt < 1 or used === nxt then
        nxt = nxt + 2 * n
    end
    alreadyUsed = used === nxt
    a << nxt
    if not alreadyUsed then
        used << nxt
        if nxt >= 0 and nxt <= 1000 then
            used1000 << nxt
        end
    end
    if n == 14 then
        print "The first 15 terms of the Recaman's sequence are ", a, "\n"
    end
    if not foundDup and alreadyUsed then
        print "The first duplicated term is a[", n, "] = ", nxt, "\n"
        foundDup = true
    end
    if used1000.size == 1001 then
        print "Terms up to a[", n, "] are needed to generate 0 to 1000\n"
    end
    n = n + 1
end
