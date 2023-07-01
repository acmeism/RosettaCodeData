function iseban(n::Integer)
    b, r = divrem(n, oftype(n, 10 ^ 9))
    m, r = divrem(r, oftype(n, 10 ^ 6))
    t, r = divrem(r, oftype(n, 10 ^ 3))
    m, t, r = (30 <= x <= 66 ? x % 10 : x for x in (m, t, r))
    return all(in((0, 2, 4, 6)), (b, m, t, r))
end

println("eban numbers up to and including 1000:")
println(join(filter(iseban, 1:100), ", "))

println("eban numbers between 1000 and 4000 (inclusive):")
println(join(filter(iseban, 1000:4000), ", "))

println("eban numbers up to and including 10000: ", count(iseban, 1:10000))
println("eban numbers up to and including 100000: ", count(iseban, 1:100000))
println("eban numbers up to and including 1000000: ", count(iseban, 1:1000000))
println("eban numbers up to and including 10000000: ", count(iseban, 1:10000000))
println("eban numbers up to and including 100000000: ", count(iseban, 1:100000000))
println("eban numbers up to and including 1000000000: ", count(iseban, 1:1000000000))
