function iskaprekar(n::Integer)
    n == 1 && return true
    test(a, b) = n == a + b && b ≠ 0
    str = string(n^2)
    any(test(parse(Int, str[1:i]), parse(Int, str[i+1:end])) for i = 1:length(str)-1)
end

@show filter(iskaprekar, 1:10000)
@show count(iskaprekar, 1:10000)
