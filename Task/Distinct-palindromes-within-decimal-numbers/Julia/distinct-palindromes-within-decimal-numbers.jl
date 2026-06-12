function allpalindromes(a::Vector{T}) where T
    pals = Vector{Vector{T}}([[x] for x in a])
    len = length(a)
    len < 2 && return pals
    a == reverse(a) && push!(pals, a)
    len == 2 && return pals
    for i in 2:len
        left = a[1:i]
        left == reverse(left) && push!(pals, left)
    end
    return unique(vcat(pals, allpalindromes(a[2:end])))
end

println("Number  Palindromes")
for n in 100:125
    println(" ", rpad(n, 7), sort(allpalindromes(digits(n))))
end

palindrome2plusfree(n) = (a = allpalindromes(digits(n)); all(x -> length(x) == 1, a))

println("\nNumber                    Has no >= 2 digit palindromes")
for n in [9, 169, 12769, 1238769, 123498769, 12346098769, 1234572098769, 123456832098769,
    12345679432098769, 1234567905432098769, 123456790165432098769, 83071934127905179083, 1320267947849490361205695]
    println(rpad(n, 26), palindrome2plusfree(n))
end
