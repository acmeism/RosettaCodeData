euler(f::Function, T::Number, t0::Int, t1::Int, h::Int) = collect(begin T += h * f(T); T end for t in t0:h:t1)

# Prints a series of arbitrary values in a tabular form, left aligned in cells with a given width
tabular(width, cells...) = println(join(map(s -> rpad(s, width), cells)))

# prints the table according to the task description for h=5 and 10 sec
for h in (5, 10)
    print("Step $h:\n\n")
    tabular(15, "Time", "Euler", "Analytic")
    t = 0
    for T in euler(y -> -0.07 * (y - 20.0), 100.0, 0, 100, h)
        tabular(15, t, round(T,digits=6), round(20.0 + 80.0 * exp(-0.07t), digits=6))
        t += h
    end
    println()
end
