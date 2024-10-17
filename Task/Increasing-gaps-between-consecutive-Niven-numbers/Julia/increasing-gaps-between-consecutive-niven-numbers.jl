using Formatting

function findharshadgaps(N)
    isharshad(i) = i % sum(digits(i)) == 0
    println("Gap Index  Number Index  Niven Number")
    lastnum, lastnumidx, biggestgap = 1, 1, 0
    for i in 2:N
        if isharshad(i)
            if (gap = i - lastnum) > biggestgap
                println(lpad(gap, 5), lpad(format(lastnumidx, commas=true), 14),
                    lpad(format(lastnum, commas=true), 18))
                biggestgap = gap
            end
            lastnum, lastnumidx = i, lastnumidx + 1
        end
    end
end

findharshadgaps(50_000_000_000)
