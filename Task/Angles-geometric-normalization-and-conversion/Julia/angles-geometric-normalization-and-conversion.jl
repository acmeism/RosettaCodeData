using Formatting

d2d(d) = d % 360
g2g(g) = g % 400
m2m(m) = m % 6400
r2r(r) = r % 2π
d2g(d) = d2d(d) * 10 / 9
d2m(d) = d2d(d) * 160 / 9
d2r(d) = d2d(d) * π / 180
g2d(g) = g2g(g) * 9 / 10
g2m(g) = g2g(g) * 16
g2r(g) = g2g(g) * π / 200
m2d(m) = m2m(m) * 9 / 160
m2g(m) = m2m(m) / 16
m2r(m) = m2m(m) * π / 3200
r2d(r) = r2r(r) * 180 / π
r2g(r) = r2r(r) * 200 / π
r2m(r) = r2r(r) * 3200 / π

fmt(x::Real, width=16) = Int(round(x)) == x ? rpad(Int(x), width) :
                                              rpad(format(x, precision=7), width)
fmt(x::String, width=16) = rpad(x, width)

const t2u = Dict("degrees" => [d2d, d2g, d2m, d2r],
    "gradians" => [g2d, g2g, g2m, g2r], "mils" => [m2d, m2g, m2m, m2r],
    "radians" => [r2d, r2g, r2m, r2r])

function testconversions(arr)
    println("Number          Units           Degrees          Gradians        Mils            Radians")
    for num in arr, units in ["degrees", "gradians", "mils", "radians"]
        print(fmt(num), fmt(units))
        for f in t2u[units]
            print(fmt(f(num)))
        end
        println()
    end
end

testconversions([-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000])
