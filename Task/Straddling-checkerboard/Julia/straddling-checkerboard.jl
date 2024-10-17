function straddlingcheckerboard(board, msg, doencode)
    lookup = Dict()
    reverselookup = Dict()
    row2 = row3 = slash = -1
    function encode(x)
        s = ""
        for ch in replace(replace(uppercase(x), r"([01-9])", s";=;\1"), r";=;", slash)
            c = string(ch)
            if haskey(lookup, c)
                s *= lookup[c]
            elseif contains("0123456789", c)
                s *= c
            end
        end
        s
    end
    function decode(x)
        s = ""
        i = 1
        while i <= length(x)
            c = string(x[i])
            if haskey(reverselookup, c)
                s *= reverselookup[c]
                i += 1
            else
                if "$c$(x[i+1])" == slash
                    s *= string(x[i+2])
                    i += 3
                else
                    s *= reverselookup["$c$(x[i+1])"]
                    i += 2
                end
            end
        end
        s
    end
    for (i,c) in enumerate(board)
        c = string(c)
        if c == " "
            if row2 == -1
                row2 = i-1
            else
                row3 = i-1
            end
        else
            if i < 11
                lookup[c] = "$(i-1)"; reverselookup["$(i-1)"] =  c
            elseif i < 21
                lookup[c] = "$row2$(i-11)"; reverselookup["$row2$(i-11)"] = c
            else
                lookup[c] = "$row3$(i-21)"; reverselookup["$row3$(i-21)"] = c
            end
            if c == "/"
                slash = lookup[c]
            end
        end
    end
    doencode ? encode(msg) : decode(msg)
end

btable = "ET AON RISBCDFGHJKLMPQ/UVWXYZ."
message = "Thecheckerboardcakerecipespecifies3largeeggsand2.25cupsofflour."
encoded = straddlingcheckerboard(btable, message, true)
decoded = straddlingcheckerboard(btable, encoded, false)
println("Original: $message\nEncoded:  $encoded\nDecoded:  $decoded")
