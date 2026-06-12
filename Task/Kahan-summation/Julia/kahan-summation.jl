epsilon() = begin eps = 1.0; while 1.0 + eps != 1.0 eps /= 2.0 end; eps end

function kahansum(arr)
    tot = temp = 0.0
    for x in arr
        y = x - temp
        t = tot + y
        temp = (t - tot) - y
        tot = t
    end
    return tot
end

const a = 1.0
const ep = epsilon()
const b = -ep
const v = [a, ep, b]

println("Epsilon is $ep")
println("(a + ep) + -ep = ", (a + ep) + b)
println("Kahan sum is ", kahansum(v))
println("BigFloat sum is ", (BigFloat(a) + ep) + b)
