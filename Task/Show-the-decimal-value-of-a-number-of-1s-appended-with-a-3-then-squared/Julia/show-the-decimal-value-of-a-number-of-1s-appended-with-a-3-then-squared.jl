println("n  (10^(n+1) - 1) ÷ 9 + 2)       squared")
for n in 0:7
    println(rpad(n, 14), rpad((big"10"^(n+1) - 1) ÷ 9 + 2, 19), ((big"10"^(n+1) - 1) ÷ 9 + 2)^2)
end
