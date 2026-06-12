def mapp(x, min_x, max_x, min_to, max_to)
    return (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to
end

def chebyshevCoef(func, min, max, coef)
    n = coef.length

    for i in 0 .. n-1 do
        m = mapp(Math.cos(Math::PI * (i + 0.5) / n), -1, 1, min, max)
        f = func.call(m) * 2 / n

        for j in 0 .. n-1 do
            coef[j] = coef[j] + f * Math.cos(Math::PI * j * (i + 0.5) / n)
        end
    end
end

N = 10
def main
    c = Array.new(N, 0)
    min = 0
    max = 1
    chebyshevCoef(lambda { |x| Math.cos(x) }, min, max, c)

    puts "Coefficients:"
    puts c
end

main()
