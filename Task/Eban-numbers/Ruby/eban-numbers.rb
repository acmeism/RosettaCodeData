def main
    intervals = [
        [2, 1000, true],
        [1000, 4000, true],
        [2, 10000, false],
        [2, 100000, false],
        [2, 1000000, false],
        [2, 10000000, false],
        [2, 100000000, false],
        [2, 1000000000, false]
    ]
    for intv in intervals
        (start, ending, display) = intv
        if start == 2 then
            print "eban numbers up to and including %d:\n" % [ending]
        else
            print "eban numbers between %d and %d (inclusive):\n" % [start, ending]
        end

        count = 0
        for i in (start .. ending).step(2)
            b = (i / 1000000000).floor
            r = (i % 1000000000)
            m = (r / 1000000).floor
            r = (r % 1000000)
            t = (r / 1000).floor
            r = (r % 1000)
            if m >= 30 and m <= 66 then
                m = m % 10
            end
            if t >= 30 and t <= 66 then
                t = t % 10
            end
            if r >= 30 and r <= 66 then
                r = r % 10
            end
            if b == 0 or b == 2 or b == 4 or b == 6 then
                if m == 0 or m == 2 or m == 4 or m == 6 then
                    if t == 0 or t == 2 or t == 4 or t == 6 then
                        if r == 0 or r == 2 or r == 4 or r == 6 then
                            if display then
                                print ' ', i
                            end
                            count = count + 1
                        end
                    end
                end
            end
        end
        if display then
            print "\n"
        end
        print "count = %d\n\n" % [count]
    end
end

main()
