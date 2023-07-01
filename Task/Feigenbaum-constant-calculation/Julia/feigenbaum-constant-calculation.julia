# http://en.wikipedia.org/wiki/Feigenbaum_constant

function feigenbaum_delta(imax=23, jmax=20)
    a1, a2, d1 = BigFloat(1.0), BigFloat(0.0), BigFloat(3.2)
    println("Feigenbaum's delta constant incremental calculation:\ni   δ\n1   3.20")
    for i in 2:imax
        a = a1 + (a1 - a2) / d1
        for j in 1:jmax
            x, y = 0, 0
            for k in 1:2^i
                y = 1 - 2 * x * y
                x = a - x * x
            end
            a -= x / y
        end
        d = (a1 - a2) / (a - a1)
        println(rpad(i, 4), lpad(d, 4))
        d1, a2 = d, a1
        a1 = a
    end
end

feigenbaum_delta()
