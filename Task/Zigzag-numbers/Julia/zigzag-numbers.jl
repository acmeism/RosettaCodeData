iszigzag(a) = all(i -> isodd(i) ? a[i] < a[i+1] : a[i] > a[i+1], firstindex(a):lastindex(a)-1)

""" Mutates ''itr'' into the next permutation with the zigzag property.
    Returns true if a new permutation was found, otherwise false.
"""
function next_zigzag_perm!(itr)::Bool
    while true
        (isempty(itr) || length(itr) == 1) && break
        i = findlast(idx -> itr[idx+1] > itr[idx], firstindex(itr):lastindex(itr)-1)
        if isnothing(i)
            reverse!(itr)
            break
        end
        j = findlast(idx -> itr[idx] > itr[i], i+1:lastindex(itr)) + i
        itr[i], itr[j] = itr[j], itr[i]
        reverse!(itr, i + 1)
        iszigzag(itr) && return true
    end
    return false
end

""" Lazy iterator to generate zigzag permutations of length ''n'' """
struct Zigzags
    n::Int
end
function Base.iterate(zz::Zigzags, state = collect(1:zz.n))
    return next_zigzag_perm!(state) ? (state, state) : nothing
end

""" Testing: generate zigzag permutations and print totals for various N."""
function testzigzags(n_listings, n_totals)
    for n in 1:n_listings
        println("\n\nZigZag Permutations for N = $n:")
        if n < 3
            print(collect(1:n))
        else
            for a in Zigzags(n)
                print(a, " ")
            end
            println()
        end
    end
    zzn = [Int128(1)]
    println("\nN     Zigzags\n--------------------------------\n 1    1")
    for m in 1:n_totals-1
        zzn = iseven(m) ? [reverse(cumsum(reverse(zzn))); 0] : [0; cumsum(zzn)]
        println(lpad(m + 1, 2), "    ", sum(zzn))
    end
end

testzigzags(5, 30)
