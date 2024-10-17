using Printf

function balancedbrackets(str::AbstractString)
    i = 0
    for c in str
        if c == '[' i += 1 elseif c == ']' i -=1 end
        if i < 0 return false end
    end
    return i == 0
end

brackets(n::Integer) = join(shuffle(collect(Char, "[]" ^ n)))

for (test, pass) in map(x -> (x, balancedbrackets(x)), collect(brackets(i) for i = 0:8))
    @printf("%22s%10s\n", test, pass ? "pass" : "fail")
end
