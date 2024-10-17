using Lazy, Formatting

firstlast(a) = 10 * a[end] + a[1]
isgapful(n) = (d = digits(n); length(d) < 3 || (m = firstlast(d)) != 0 && mod(n, m) == 0)
gapfuls(start) = filter(isgapful, Lazy.range(start))

for (x, n) in [(100, 30), (1_000_000, 15), (1_000_000_000, 10)]
    println("First $n gapful numbers starting at ", format(x, commas=true), ":\n",
        take(n, gapfuls(x)))
end
