STX = "\u0002"
ETX = "\u0003"

def bwt(s)
    for c in s.split('')
        if c == STX or c == ETX then
            raise ArgumentError.new("Input can't contain STX or ETX")
        end
    end

    ss = ("%s%s%s" % [STX, s, ETX]).split('')
    table = []
    for i in 0 .. ss.length - 1
        table.append(ss.join)
        ss = ss.rotate(-1)
    end

    table = table.sort
    return table.map{ |e| e[-1] }.join
end

def ibwt(r)
    len = r.length
    table = [""] * len
    for i in 0 .. len - 1
        for j in 0 .. len - 1
            table[j] = r[j] + table[j]
        end
        table = table.sort
    end
    for row in table
        if row[-1] == ETX then
            return row[1 .. -2]
        end
    end
    return ""
end

def makePrintable(s)
    s = s.gsub(STX, "^")
    return s.gsub(ETX, "|")
end

def main
    tests = [
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        "\u0002ABC\u0003"
    ]
    for test in tests
        print makePrintable(test), "\n"
        print " --> "

        begin
            t = bwt(test)
            print makePrintable(t), "\n"

            r = ibwt(t)
            print " --> ", r, "\n\n"
        rescue ArgumentError => e
            print e.message, "\n"
            print " -->\n\n"
        end
    end
end

main()
