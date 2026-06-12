using Primes

""" Get N numbers in the series of Wolstenholme numbers """
wolstenholme(N) = map(numerator, accumulate(+, (1 // (i*i) for i in big"1":N)))

""" Abbreviate a large string by showing beginning / end and number of chars """
function abbreviate(s, term = "digits", thresh = 50, idx = thresh ÷ 2 - 3)
    w = length(s)
    return w < thresh ? s : s[begin:begin+idx] * ".." * s[end-idx:end] * " ($w $term)"
end

""" Run the tasks at rosettacode.org/wiki/Wolstenholme_numbers """
function process_wolstenholmes(nmax = 10000, filterto = 2000)
    wols = wolstenholme(nmax)
    println("Wolstenholme numbers 1:20, 500, 1000, 2500, 5000, 10000:")
    for i in [1:20; [500, 1000, 2500, 5000, 10000]]
        println(rpad(i, 5), ": ", abbreviate(string(wols[i])))
    end
    println("\nFifteen Wolstenholme primes:")
    for (i, n) in enumerate(filter(isprime, @view wols[begin:filterto]))
        println(rpad(i, 2), ": ", abbreviate(string(n)))
    end
end

process_wolstenholmes()
