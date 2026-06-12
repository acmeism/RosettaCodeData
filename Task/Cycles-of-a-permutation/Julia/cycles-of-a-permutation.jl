""" A Perm is a permutation in one-line form. `a` is a shuffled gapless 1-based range of Int. """
struct Perm
    a::Vector{Int}
    function Perm(arr::Vector{Int})
        if sort(arr) != collect(1:length(arr))
            error("$arr must be permutation of 1-based integer range")
        end
        return new(arr)
    end
end

""" Create a Perm from its cycle vectors """
function Perm(cycles::Vector{Vector{Int}}; addsingles = true)
    elements = reduce(vcat, cycles)
    if addsingles
        for elem in filter(x -> !(x in elements), 1:maximum(elements))
        push!(cycles, [elem])
        push!(elements, elem)
        end
    end
    a = collect(1:length(elements))
    sort!(elements) != a && error("Invalid cycles <$cycles> for creating a Perm")
    for c in cycles
        len = length(c)
        for i in 1:len
            j, n = c[i], c[mod1(i + 1, len)]
            a[j] = n
        end
    end
    return Perm(a)
end

""" length of Perm """
Base.length(p::Perm) = length(p.a)

""" permutation signage for the Perm """
Base.sign(p::Perm) = iseven(sum(c -> iseven(length(c)), permcycles(p))) ? 1 : -1

""" order of permutation for Perm """
order(p::Perm) = lcm(map(length, permcycles(p)))

""" Composition of Perm permutations with the * operator """
function Base.:*(p1:: Perm, p2::Perm)
    len = length(p1)
    len != length(p2) && error("Permutations must be of same length")
    return Perm([p1.a[p2.a[i]] for i in 1:len])
end

""" inverse of a Perm """
function Base.inv(p::Perm)
    a = zeros(Int, length(p))
    for i in 1:length(p)
        j = p.a[i]
        a[j] = i
    end
    return Perm(a)
end

""" Get cycles of a Perm permutation as a vector of integer vectors, optionally with singles """
function permcycles(p::Perm; includesingles = false)
    pdict, cycles = Dict(enumerate(p.a)), Vector{Int}[]
    for i in 1:length(p.a)
        if (j = pop!(pdict, i, 0)) != 0
            c = [i]
            while i != j
                push!(c, j)
                j = pop!(pdict, j)
            end
            push!(cycles, c)
        end
    end
    return includesingles ? cycles : filter(c -> length(c) > 1, cycles)
end

""" Perm prints in cycle or optionally oneline format """
function Base.print(io::IO, p::Perm; oneline = false, printsinglecycles = false, AlfBetty = false)
    if length(p) == 0
        print(io, "()")
    end
    if oneline
        width = length(string(maximum(p.a))) + 1
        print(io, "[ " * prod(map(n -> "$n ", p.a)) * "]")
    else
        cycles = permcycles(AlfBetty ? inv(p) : p, includesingles = printsinglecycles)
        print(io, prod(c -> "(" * string(c)[begin+1:end-1] * ") ", cycles))
    end
end

""" Create a Perm from a string with only one of each of its letters """
Perm(s::AbstractString) = Perm([findfirst(==(c), String(sort(unique(collect(s))))) for c in s])

""" Create a Perm from two strings permuting first string to the second one """
Perm(s1::AbstractString, s2::AbstractString) = Perm([findfirst(==(c), s1) for c in s2])

""" Create a permuted string from another string using a Perm """
permutestring(s::AbstractString, p::Perm) = String([s[i] for i in p.a])

function testAlfBettyPerms()
    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    daystrings = ["HANDYCOILSERUPT", "SPOILUNDERYACHT", "DRAINSTYLEPOUCH",
       "DITCHSYRUPALONE", "SOAPYTHIRDUNCLE", "SHINEPARTYCLOUD", "RADIOLUNCHTYPES"]
    dayperms = [Perm(daystrings[mod1(i - 1, 7)], daystrings[i]) for i in 1:length(days)]
    print("On Thursdays Alf and Betty should rearrange\ntheir letters using these cycles:         ")
    print(stdout, dayperms[4], AlfBetty = true)
    println("\n\nSo that $(daystrings[3]) becomes $(daystrings[4])")
    print("\nor they could use the one-line notation:  ")
    print(stdout, dayperms[4]; oneline = true)
    print("\n\n\nTo revert to the Wednesday arrangement they\nshould use these cycles:  ")
    print(stdout, inv(dayperms[4]), AlfBetty = true)
    print("\n\nor with the one-line notation:  " )
    print(stdout, inv(dayperms[4]); oneline = true)
    println("\n\nSo that $(daystrings[4]) becomes $(daystrings[3])")
    println("\n\nStarting with the Sunday arrangement and applying each of the daily")
    println("permutations consecutively, the arrangements will be:\n")
    println(" "^6, daystrings[7], "\n")
    for i in 1:length(days)
        i == 7 && println()
        println(days[i], ":  ", permutestring(daystrings[mod1(i - 1, 7)], dayperms[i]))
    end
    Base.println("\n\nTo go from Wednesday to Friday in a single step they should use these cycles: ")
    print(stdout, Perm(daystrings[3], daystrings[5]), AlfBetty = true)
    println("\n\nSo that $(daystrings[3]) becomes $(daystrings[5])")
    println("\n\nThese are the signatures of the permutations:\n\n  Mon Tue Wed Thu Fri Sat Sun")
    for i in 1:length(days)
        j = i == 1 ? length(days) : i - 1
        print(lpad(sign(Perm(daystrings[mod1(i - 1, 7)], daystrings[i])), 4))
    end
    println("\n\nThese are the orders of the permutations:\n\n  Mon Tue Wed Thu Fri Sat Sun")
    for i in 1:7
        print(lpad(order(dayperms[i]), 4))
    end
    println("\n\nApplying the Friday cycle to a string 10 times:\n")
    pFri, str = dayperms[5], "STOREDAILYPUNCH"
    println("   $str\n")
    for i in 1:10
        str = permutestring(str, pFri)
        println(lpad(i, 2), " ", str, i == 9 ? "\n" : "")
    end
end

testAlfBettyPerms()
