function penholodigital(base)
    penholodigitals = [typeof(base)[] for _ in 1:Threads.nthreads()]
    digitbuf = [zeros(typeof(base), base-1) for _ in 1:Threads.nthreads()]
    hi, lo = isqrt(evalpoly(base, 1:base-1)), isqrt(evalpoly(base, base-1:-1:1))
    @Threads.threads for n in lo:hi
        dig = digitbuf[Threads.threadid()]
        digits!(dig, n * n; base)
        0 in dig && continue
        if all(i -> count(==(i), dig) == 1, 1:base-1)
            push!(penholodigitals[Threads.threadid()], n * n)
        end
    end
    return sort!(vcat(penholodigitals...))
end

for j in 9:19
    @time begin
        allpen = penholodigital(j < 17 ? j : Int128(j))
        println("There are a total of $(length(allpen)) penholodigital squares in base $j:")
        if length(allpen) > 0
            for (i, n) in (j < 14 ? enumerate(allpen) : enumerate([allpen[begin], allpen[end]]))
                print(string(isqrt(n), base=j), "² = ", string(n, base=j), i %3 == 0 ? "\n" :  "  ")
            end
        end
    end
    println("\n")
end
