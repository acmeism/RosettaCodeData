def linearCombo(c)
    sb = ""
    c.each_with_index { |n, i|
        if n == 0 then
            next
        end
        if n < 0 then
            if sb.length == 0 then
                op = "-"
            else
                op = " - "
            end
        elsif n > 0 then
            if sb.length > 0 then
                op = " + "
            else
                op = ""
            end
        else
            op = ""
        end
        av = n.abs()
        if av != 1 then
            coeff = "%d*" % [av]
        else
            coeff = ""
        end
        sb = sb + "%s%se(%d)" % [op, coeff, i + 1]
    }
    if sb.length == 0 then
        return "0"
    end
    return sb
end

def main
    combos = [
        [1, 2, 3],
        [0, 1, 2, 3],
        [1, 0, 3, 4],
        [1, 2, 0],
        [0, 0, 0],
        [0],
        [1, 1, 1],
        [-1, -1, -1],
        [-1, -2, 0, -3],
        [-1],
    ]

    for c in combos do
        print "%-15s  ->  %s\n" % [c, linearCombo(c)]
    end
end

main()
