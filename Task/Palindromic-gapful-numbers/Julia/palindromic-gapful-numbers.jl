import Base.iterate, Base.IteratorSize, Base.IteratorEltype

struct Palindrome x1::UInt8; x2::UInt8; outer::UInt8; end
Base.IteratorSize(p::Palindrome) = Base.IsInfinite()
Base.IteratorEltype(g::Palindrome) = Vector{Int8}

function Base.iterate(p::Palindrome, state=(UInt8[p.x1]))
    arr, len = [p.outer; state; p.outer], length(state)
    if all(c -> c == p.x2, state)
        return arr, fill(p.x1, len + 1)
    end
    for i in (len+1)÷2:-1:1
        if state[i] < p.x2
            state[len - i + 1] = state[i] = state[i] + one(UInt8)
            return arr, state
        else
            state[len - i + 1] = state[i] = p.x1
        end
    end
    state[1] += one(UInt8)
    push!(state, state[1])
    return arr, state
end

asint(s) = foldl((i, j) -> 10i + j, s)
isgapful(a) = mod(asint(a), a[1] * 11) == 0
GapfulPalindrome(i) = Iterators.filter(isgapful, Iterators.take(Palindrome(0, 9, i), 100000000000))

function testpal()
    for (lastones, outof) in [(20, 20), (15, 100), (10, 1000), (10, 10000), (10, 100000), (10, 1000000), (10, 10000000)]
        @time begin
            println("\nLast digit | Last $lastones of $outof palindromic gapful numbers from 100\n",
                "-----------|----------------------------------------------------------------------------------------------------------------")
            output = fill("", 9)
            Threads.@threads for i in 1:9
                gplist = sort!(asint.(collect(Iterators.take(GapfulPalindrome(i), outof))))
                output[i] = "     $i        " * string(gplist[end-lastones+1:end]) * "\n"
            end
            foreach(print, output)
        end
    end
end

testpal()
