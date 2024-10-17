# v0.0.6

open("unixdict.txt") do txtfile
    rule1, notrule1, rule2, notrule2 = 0, 0, 0, 0
    for word in eachline(txtfile)
        # "I before E when not preceded by C"
        if ismatch(r"ie"i, word)
            if ismatch(r"cie"i, word)
                notrule1 += 1
            else
                rule1 += 1
            end
        end
        # "E before I when preceded by C"
        if ismatch(r"ei"i, word)
            if ismatch(r"cei"i, word)
                rule2 += 1
            else
                notrule2 += 1
            end
        end
    end

    print("Plausibility of \"I before E when not preceded by C\": ")
    println(rule1 > 2 * notrule1 ? "PLAUSIBLE" : "UNPLAUSIBLE")
    print("Plausibility of \"E before I when preceded by C\":")
    println(rule2 > 2 * notrule2 ? "PLAUSIBLE" : "UNPLAUSIBLE")
end
