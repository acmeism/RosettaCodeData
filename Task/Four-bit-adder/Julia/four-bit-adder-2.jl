xavail = trues(15,15)
xcnt = 0
xgoal = 10
println("Testing adder with 4-bit words:")
while xcnt < xgoal
    m = rand(1:15)
    n = rand(1:15)
    xavail[m,n] || continue
    xavail[m,n] = xavail[n,m] = false
    xcnt += 1
    (s, c) = adder(m, n)
    oflow = c ? "*" : ""
    print(@sprintf "    %2d + %2d = %2d => " m n m+n)
    println(@sprintf("%s + %s = %s%s",
                     bits(m)[end-3:end],
                     bits(n)[end-3:end],
                     bits(s), oflow))
end
