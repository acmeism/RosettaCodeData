using Combinatorics, Primes

function primetriangle(nrows::Integer)
    nrows < 2 && error("number of rows requested must be > 1")
    pmask, spinlock = primesmask(2 * (nrows + 1)), Threads.SpinLock()
    counts, rowstrings = [1; zeros(Int, nrows - 1)], ["" for _ in 1:nrows]
    for r in 2:nrows
        @Threads.threads for e in collect(permutations(2:2:r))
            p = zeros(Int, r - 1)
            for o in permutations(3:2:r)
                i = 0
                for (x, y) in zip(e, o)
                    p[i += 1] = x
                    p[i += 1] = y
                end
                length(e) > length(o) && (p[i += 1] = e[end])
                if pmask[p[i] + r + 1] && pmask[p[begin] + 1] && all(j -> pmask[p[j] + p[j + 1]], 1:r-2)
                    lock(spinlock)
                    if counts[r] == 0
                        rowstrings[r] = "  1" * prod([lpad(n, 3) for n in p]) * lpad(r + 1, 3) * "\n"
                    end
                    counts[r] += 1
                    unlock(spinlock)
                end
            end
        end
    end
    println("  1  2\n" * prod(rowstrings), "\n", counts)
end

@time primetriangle(16)
