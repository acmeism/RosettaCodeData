using Printf

function middle3(n::Integer)
    l = ndigits(n)
    iseven(l) && error("n must have an odd number of digits")
    l < 3 && error("n must have 3 digits or more")
    mid = (l + 1) ÷ 2
    abs(n) ÷ 10^(mid-2) % 10^3
end

for n = [123, 12345, 1234567, 987654321, 10001, -10001, -123,
         -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0]
    @printf("%10d -> %s\n", n, try middle3(n) catch e e.msg end)
end
