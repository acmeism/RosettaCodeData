isCurzon(n, k) = (BigInt(k)^n + 1) % (k * n + 1) == 0

function printcurzons(klow, khigh)
    for k in filter(iseven, klow:khigh)
        n, curzons = 0, Int[]
        while length(curzons) < 1000
            isCurzon(n, k) && push!(curzons, n)
            n += 1
        end
        println("Curzon numbers with k = $k:")
        foreach(p -> print(lpad(p[2], 5), p[1] % 25 == 0 ? "\n" : ""), enumerate(curzons[1:50]))
        println("    Thousandth Curzon with k = $k: ", curzons[1000])
    end
end

printcurzons(2, 10)
