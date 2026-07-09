using Format
using ResumableFunctions

@resumable function gen_upsidedowns()
    """ generate upside-down numbers (OEIS A299539) """
    wrappings = [[1, 9], [2, 8], [3, 7], [4, 6],
                   [5, 5], [6, 4], [7, 3], [8, 2], [9, 1]]
    evens = [19, 28, 37, 46, 55, 64, 73, 82, 91]
    odds = [5]

    ndigits, odd_index, even_index, olen, elen = 1, 0, 0, 1, 9
    while true
        if isodd(ndigits)
            if olen > odd_index
                @yield  odds[begin + odd_index]
                odd_index += 1
            else
                # build next odds, but switch to evens
                odds = let src = odds, nd = ndigits
                    [hi * 10^(nd + 1) + 10 * i + lo for i in src, (hi, lo) in wrappings]
                end
                ndigits += 1
                odd_index = 0
                olen = length(odds)
            end
        else
            if elen > even_index
                @yield evens[begin + even_index]
                even_index += 1
            else
                # build next evens, but switch to odds
                evens = let src = evens, nd = ndigits
                    [hi * 10^(nd + 1) + 10 * i + lo for i in src, (hi, lo) in wrappings]
                end
                ndigits += 1
                even_index = 0
                elen = length(evens)
            end
        end
    end
end

println("First fifty upside-downs:")
for (udcount, udnumber) in enumerate(gen_upsidedowns())
    if udcount <= 50
        print(lpad(udnumber, 5), udcount % 10 == 0 ? "\n" : "")
    elseif udcount == 500
        println("\nFive hundredth: ", format(udnumber, commas = true))
    elseif udcount == 5000
        println("Five thousandth: ", format(udnumber, commas = true))
    elseif udcount == 50_000
        println("Fifty thousandth: ", format(udnumber, commas = true))
    elseif udcount == 500_000
        println("Five hundred thousandth: ", format(udnumber, commas = true))
    elseif udcount == 5_000_000
        println("Five millionth: ", format(udnumber, commas = true))
        break
    end
end
