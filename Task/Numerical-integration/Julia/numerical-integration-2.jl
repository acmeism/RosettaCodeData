leftrect(f, x, _) = f(x)
midrect(f, x, h) = f(x + h / 2)
rightrect(f, x, h) = f(x + h)
trapezium(f, x, h) = (f(x) + f(x + h)) / 2
simpson(f, x, h) = (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6
cube(x) = x * x * x
reciprocal(x) = inv(x)

function integrate(f, a, b, steps, meth)
    h = (b - a) / steps
    return h * sum(meth(f, a + i * h, h) for i in 0:steps-1)
end

for (a, b, steps, fun) in [
    (0, 1, 100, cube),
    (1, 100, 1000, reciprocal),
    (0, 5000, 5_000_000, identity),
    (0, 6000, 6_000_000, identity)]
    for rule in [leftrect, midrect, rightrect, trapezium, simpson]
        println(string(fun) * " integrated using " * string(rule))
        println("    from $a to $b ($steps steps) = ",
            round(integrate(fun, a, b, steps, rule), sigdigits=14))
    end
end
