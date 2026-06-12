isstrange(n::Integer) = (d = digits(n); all(i -> abs(d[i] - d[i + 1]) ∈ [2, 3, 5, 7], 1:length(d)-1))

function filter_open_interval(start, stop, f, doprint=true, rowlength=92)
    colsize = length(string(stop)) + 1
    columns, ncount = rowlength ÷ colsize, 0
    println("Finding numbers matching $f for open interval ($start, $stop):\n")
    for n in start+1:stop-1
        if f(n)
            ncount += 1
            doprint && print(rpad(n, colsize), ncount % columns == 0 ? "\n" : "")
        end
    end
    println("\n\nThe total found was $ncount\n\n")
end

filter_open_interval(100, 500, isstrange)
