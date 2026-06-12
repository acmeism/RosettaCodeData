using Primes
using Memoize

""" Return the factors of n, including 1, n """
function factors(n::T)::Vector{T} where T <: Integer
  sort(vec(map(prod, Iterators.product((p.^(0:m) for (p, m) in eachfactor(n))...))))
end

""" Uses the first definition and recursion to generate the sequences """
function more_multiples(to_seq, from_seq)
    onemores = [[to_seq; i] for i in from_seq if i > to_seq[end] && i % to_seq[end] == 0]
    isempty(onemores) && return Int[]
    return append!(onemores, mapreduce(seq -> more_multiples(seq, from_seq), append!, onemores))
end


""" See reference paper by Erdos, page 1 """
@memoize function kfactors(n)
    a = factors(n)
    return sum(kfactors(n ÷ d) for d in a[begin+1:end]) + 1
end

listing = sort!(push!(map(a -> push!(a, 48), more_multiples([1], factors(48)[begin+1:end-1])), [1, 48]))
println("48 sequences using first definition:")
for (i, seq) in enumerate(listing)
    print(rpad(seq, 22), i % 4 == 0 ? "\n" : "")
end

println("\n48 sequences using second definition:")
for (i, seq) in enumerate(listing)
    seq2 = [seq[j] ÷ seq[j - 1] for j in 2:length(seq)]
    print(rpad(seq2, 20), i % 4 == 0 ? "\n" : "")
end

println("\nOEIS A163272: ")
for n in 0:2_400_000
    if n == 0 || kfactors(n) == n
        print(n, ",  ")
    end
end

