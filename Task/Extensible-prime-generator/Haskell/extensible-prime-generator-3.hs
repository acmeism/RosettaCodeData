import Collections      # to get the Heap class for use as a Priority Queue
record filter(composite, prime)  # next composite involving this prime

procedure main()
    every writes((primes()\20)||" " | "\n")
    every p := primes() do if 100 < p < 150 then writes(p," ") else if p >= 150 then break write()
    every (n := 0, p := primes()) do if 7700 < p < 8000 then n +:= 1 else if p >= 8000 then break write(n)
    every (i := 1, p := primes()) do if (i+:=1) >= 10000 then break write(p)
end

procedure primes()
    local wheel2357, nc
    wheel2357 := [2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 6, 6, 2, 6, 4, 2,
                  6, 4, 6, 8, 4, 2, 4, 2, 4, 8, 6, 4, 6, 2, 4, 6,
                  2, 6, 6, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 10, 2, 10]
    suspend sieve(Heap(,getCompositeField), ![2,3,5.7] | (nc := 11) | (nc +:= |!wheel2357))
end

procedure sieve(pQueue, candidate)
    local nc
    if 0 = pQueue.size() then {   # 2 is prime
        pQueue.add(filter(candidate*candidate, candidate))
        return candidate
        }
    while candidate > (nc := pQueue.get()).composite do {
        nc.composite +:= nc.prime
        pQueue.add(nc)
        }
    pQueue.add(filter(nc.composite+nc.prime, nc.prime))
    if candidate < nc.composite then {   # new prime found!
        pQueue.add(filter(candidate*candidate, candidate))
        return candidate
        }

end

# Provide a function for comparing filters in the priority queue...
procedure getCompositeField(x); return x.composite; end
