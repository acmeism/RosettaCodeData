using DataStructures

function farey(n::Int)
    rst = SortedSet{Rational}(Rational[0, 1])
    for den in 1:n, num in 1:den-1
        push!(rst, Rational(num, den))
    end
    return rst
end

for n in 1:11
    print("F_$n: ")
    for frac in farey(n)
        print(numerator(frac), "/", denominator(frac), " ")
    end
    println()
end

for n in 100:100:1000
    println("F_$n has ", length(farey(n)), " fractions")
end
