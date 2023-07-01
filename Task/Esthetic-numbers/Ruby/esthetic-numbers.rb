def isEsthetic(n, b)
    if n == 0 then
        return false
    end

    i = n % b
    n2 = (n / b).floor
    while n2 > 0
        j = n2 % b
        if (i - j).abs != 1 then
            return false
        end
        n2 = n2 / b
        i = j
    end
    return true
end

def listEsths(n, n2, m, m2, perLine, all)
    esths = Array.new
    dfs = lambda {|n, m, i|
        if n <= i and i <= m then
            esths << i
        end
        if i == 0 or i > m then
            return
        end
        d = i % 10
        i1 = i * 10 + d - 1
        i2 = i1 + 2
        if d == 0 then
            dfs[n, m, i2]
        elsif d == 9 then
            dfs[n, m, i1]
        else
            dfs[n, m, i1]
            dfs[n, m, i2]
        end
    }

    for i in 0..9
        dfs[n2, m2, i]
    end

    le = esths.length
    print "Base 10: %d esthetic numbers between %d and %d:\n" % [le, n, m]
    if all then
        esths.each_with_index { |esth, idx|
            print "%d " % [esth]
            if (idx + 1) % perLine == 0 then
                print "\n"
            end
        }
        print "\n"
    else
        for i in 0 .. perLine - 1
            print "%d " % [esths[i]]
        end
        print "\n............\n"
        for i in le - perLine .. le - 1
            print "%d " % [esths[i]]
        end
        print "\n"
    end
    print "\n"
end

def main
    for b in 2..16
        print "Base %d: %dth to %dth esthetic numbers:\n" % [b, 4 * b, 6 * b]
        n = 1
        c = 0
        while c < 6 * b
            if isEsthetic(n, b) then
                c = c + 1
                if c >= 4 * b then
                    print "%s " % [n.to_s(b)]
                end
            end
            n = n + 1
        end
        print "\n"
    end
    print "\n"

    listEsths(1000, 1010, 9999, 9898, 16, true)
    listEsths(1e8, 101010101, 13 * 1e7, 123456789, 9, true)
    listEsths(1e11, 101010101010, 13 * 1e10, 123456789898, 7, false)
    listEsths(1e14, 101010101010101, 13 * 1e13, 123456789898989, 5, false)
    listEsths(1e17, 101010101010101010, 13 * 1e16, 123456789898989898, 4, false)
end

main()
