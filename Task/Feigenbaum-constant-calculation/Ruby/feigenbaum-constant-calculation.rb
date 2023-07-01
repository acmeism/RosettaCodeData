def main
    maxIt = 13
    maxItJ = 10
    a1 = 1.0
    a2 = 0.0
    d1 = 3.2
    puts " i       d"
    for i in 2 .. maxIt
        a = a1 + (a1 - a2) / d1
        for j in 1 .. maxItJ
            x = 0.0
            y = 0.0
            for k in 1 .. 1 << i
                y = 1.0 - 2.0 * y * x
                x = a - x * x
            end
            a = a - x / y
        end
        d = (a1 - a2) / (a - a1)
        print "%2d    %.8f\n" % [i, d]
        d1 = d
        a2 = a1
        a1 = a
    end
end

main()
