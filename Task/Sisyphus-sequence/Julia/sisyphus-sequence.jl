using Counters, Formatting, Primes

struct Sisyphus end

function Base.iterate(s::Sisyphus, state = (0, 0))
    n, p = state
    if n == 0
        return (1, 0), (1, 0)
    else
        if isodd(n)
            p = nextprime(p + 1)
            n += p
        else
            n ÷= 2
        end
        return (n, p), (n, p)
    end
end

function test_sisyphus()
    coun = Counter{Int}()
    println("The first 100 members of the Sisyphus sequence are:")
    for (i, (n, p)) in enumerate(Sisyphus())
        if n < 250
            coun[n] += 1
        end
        if i < 101
            print(rpad(n, 4), i % 10 == 0 ? "\n" : "")
        elseif i in [1000, 10000, 100_000, 1_000_000, 10_000_000, 100_000_000]
            print(
                rpad("\n$(format(i, commas = true))th number:", 22),
                rpad(format(n, commas = true), 14),
                "Highest prime needed: ",
                format(p, commas = true),
            )
        end
        if i == 100_000_000
            println(
                "\n\nThese numbers under 250 do not occur in the first 100,000,000 terms:",
            )
            println("    ", filter(j -> !haskey(coun, j), 1:249), "\n")
            sorteds = sort!([(p, coun[p]) for p in coun], by = last)
            maxtimes = sorteds[end][2]
            println(
                "These numbers under 250 occur the most ($maxtimes times) in the first 100,000,000 terms:",
            )
            println("    ", map(first, filter(p -> p[2] == maxtimes, sorteds)))
        elseif n == 36
            println("\nLocating the first entry in the sequence with value 36:")
            println(
                "    The sequence position: ",
                format(i, commas = true),
                " has value $n using prime ",
                format(p, commas = true),
            )
            break
        end
    end
end

test_sisyphus()
