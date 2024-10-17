function luhntest(x::Integer)
    d = reverse(digits(x))
    s = sum(d[1:2:end])
    s += sum(sum.(digits.(2d[2:2:end])))
    return s % 10 == 0
end

for card in [49927398716, 49927398717, 1234567812345678, 1234567812345670]
    println(luhntest(card) ? "PASS " : "FAIL ", card)
end
