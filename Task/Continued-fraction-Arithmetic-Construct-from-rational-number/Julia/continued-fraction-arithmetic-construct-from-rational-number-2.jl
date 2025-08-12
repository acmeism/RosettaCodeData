using ResumableFunctions

@resumable function r2cf(n1::T, n2::T)::T where T <: Integer
    while n2 > 0
        n1, (t1, n2) = n2, divrem(n1, n2)
        @yield t1
    end
end
println(collect(r2cf(1, 1))) # => [1]
println(collect(r2cf(1, 3))) # => [0, 3]
println(collect(r2cf(2, 1))) # => [2]
println(collect(r2cf(2, 3))) # => [0, 1, 3]
println(collect(r2cf(1, 2))) # => [0, 2]
println(collect(r2cf(3, 1))) # => [3]
println(collect(r2cf(23, 8))) # => [2, 1, 7]
println(collect(r2cf(13, 11))) # => [1, 5, 2]
println(collect(r2cf(22, 7))) # => [3, 7]
println(collect(r2cf(14142, 10000))) # => [1, 2, 2, 2, 2, 2, 1, 1, 29]
println(collect(r2cf(141421, 100000))) # => [1, 2, 2, 2, 2, 2, 2, 3, 1, 1, 3, 1, 7, 2]
println(collect(r2cf(1414214, 1000000))) # => [1, 2, 2, 2, 2, 2, 2, 2, 3, 6, 1, 2, 1, 12]
println(collect(r2cf(14142136, 10000000))) # => [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 1, 2, 4, 1, 1, 2]
