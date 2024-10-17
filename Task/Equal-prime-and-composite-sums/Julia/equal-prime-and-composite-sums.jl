using Primes

function getsequencematches(N, masksize = 1_000_000_000)
    pmask = primesmask(masksize)
    found, psum, csum, pindex, cindex, pcount, ccount = 0, 2, 4, 2, 4, 1, 1
    incrementpsum() = (pindex += 1; if pmask[pindex] psum += pindex; pcount += 1 end)
    incrementcsum() = (cindex += 1; if !pmask[cindex] csum += cindex; ccount += 1 end)
    while found < N
        while psum < csum
            pindex >= masksize && return
            incrementpsum()
        end
        if psum == csum
            println("Primes up to $pindex at position $pcount and composites up to $cindex at position $ccount sum to $psum.")
            found += 1
            while psum == csum
                incrementpsum()
                incrementcsum()
            end
        end
        while csum < psum
            incrementcsum()
        end
    end
end

@time getsequencematches(11)
