global mtx

procedure main(A)
    nBuckets := integer(A[1]) | 10
    nShows := integer(A[2]) | 4
    showBuckets := A[3]
    mtx := mutex()
    every !(buckets := list(nBuckets)) := ?100

    thread repeat {
        every (b1|b2) := ?nBuckets   # OK if same!
        critical mtx: xfer((buckets[b1] - buckets[b2])/2, b1, b2)
        }
    thread repeat {
        every (b1|b2) := ?nBuckets   # OK if same!
        critical mtx: xfer(integer(?buckets[b1]), b1, b2)
        }
    wait(thread repeat {
        delay(500)
        critical mtx: {
            every (sum := 0) +:= !buckets
            writes("Sum: ",sum)
            if \showBuckets then every writes(" -> "|right(!buckets, 4))
            }
        write()
        if (nShows -:= 1) <= 0 then break
        })
end

procedure xfer(x,b1,b2)
    buckets[b1] -:= x
    buckets[b2] +:= x
end
