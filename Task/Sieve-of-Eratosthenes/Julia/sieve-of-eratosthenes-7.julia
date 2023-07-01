function bench()
    print("( ")
    for p in PrimesPaged() p > 100 && break; print(p, " ") end
    println(")")
    countPrimesTo(Prime(100)) # warm up JIT
#=
    println(@time let count = 0
                      for p in PrimesPaged()
                          p > 1000000000 && break
                          count += 1
                      end; count end) # much slower counting over iteration
=#
    println(@time countPrimesTo(Prime(1000000000)))
end
bench()
