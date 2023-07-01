gsum(i) = sum(digits(i)) + i
isnonself(i) = any(x -> gsum(x) == i, i-1:-1:i-max(1, ndigits(i)*9))
const last81 = filter(isnonself, 1:5000)[1:81]

function checkselfnumbers()
    i, selfcount = 1, 0
    while selfcount <= 100_000_000 && i <= 1022727208
        if !(i in last81)
            selfcount += 1
            if selfcount < 51
                print(i, " ")
            elseif selfcount == 51
                println()
            elseif selfcount == 100_000_000
                println(i == 1022727208 ?
                    "Yes, $i is the 100,000,000th self number." :
                    "No, instead $i is the 100,000,000th self number.")
            end
        end
        popfirst!(last81)
        push!(last81, gsum(i))
        i += 1
    end
end

checkselfnumbers()
