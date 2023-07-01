using Base, StringDistances

struct Lucky
    start::Int
    nmax::Int
    Lucky(iseven, nmax) = new(iseven ? 2 : 1, nmax)
end

struct LuckyState
    nextindex::Int
    sequence::Vector{Int}
end

Base.eltype(iter::Lucky) = Int

function Base.iterate(iter::Lucky, state = LuckyState(1, collect(iter.start:2:iter.nmax)))
    if length(state.sequence) < state.nextindex
        return nothing
    elseif state.nextindex == 1
        return (iter.start, LuckyState(2, state.sequence))
    end
    result = state.sequence[state.nextindex]
    newsequence = Vector{Int}()
    for (i, el) in enumerate(state.sequence)
        if i % result != 0
            push!(newsequence, el)
        end
    end
    (result, LuckyState(state.nextindex + 1, newsequence))
end

function luckyindex(j, wanteven, k=0)
    topindex = max(j, k) + 4
    luck = Lucky(wanteven, topindex * 20)
    iter_result = iterate(luck)
    while iter_result != nothing
        (elem, state) = iter_result
        iter_result = iterate(luck, state)
        if iter_result != nothing && iter_result[2].nextindex > topindex
            return iter_result[2].sequence[k > j ? (j:k) : j]
        end
    end
    throw("Index $j out of range for nmax of $(luck.nmax).")
end

function luckyrange(j, k, wanteven)
    topvalue = max(j, k)
    luck = Lucky(wanteven, topvalue + 1)
    iter_result = iterate(luck)
    (elem, state) = iter_result # save next to last result
    while iter_result != nothing
        (elem, state) = iter_result
        iter_result = iterate(luck, state)
    end
    filter(x -> (j <= x <= k), state.sequence)
end

function helpdisplay(exitlevel=1)
    println("\n", PROGRAM_FILE, " j [-][k] [lucky|evenLucky]")
    println("\tj: index wanted or a starting point (index or value)",
            "\n\tk: optional ending point (index), \n\t-k: optional ending point (value)\n")
    helpstring =
""" | Argument(s)        |    What is printed                                  |
 |--------------------------------------------------------------------------|
 | j                  |  jth lucky number (required argument)               |
 | j , lucky          |  jth lucky number                                   |
 | j , evenLucky      |  jth even lucky number                              |
 | j  k               |  jth through kth (inclusive) lucky numbers          |
 | j  k  lucky        |  jth through kth (inclusive) lucky numbers          |
 | j  k  evenLucky    |  jth through kth (inclusive) even lucky numbers     |
 | j  -k              |  all lucky numbers in the value range [m, |k|]      |
 | j  -k  lucky       |  all lucky numbers in the value range [m, |k|]      |
 | j  -k  evenLucky   |  all even lucky numbers in the value range [m, |k|] |
 |--------------------------------------------------------------------------|\n\n"""

    println(helpstring)
    exit(exitlevel)
end

function parsecommandline()
    comma = false
    evenLucky = false
    range = false
    j = k = 0
    if length(ARGS) < 1
        helpdisplay()
    end
    for (pos, arg) in enumerate(ARGS)
        if pos == 1
            j = tryparse(Int, arg)
            if j == nothing
                println("The first argument must be a positive integer.\n")
                helpdisplay()
            end
        elseif pos == 2 || (pos == 3 && comma)
            k = tryparse(Int, arg)
            if k == nothing
                k = 0
                if arg == ","
                    comma = true
                    continue
                elseif arg == "lucky"
                    continue
                elseif arg == "evenLucky"
                    evenLucky = true
                elseif compare(Hamming(), arg, "lucky") > 0.4 || compare(Hamming(), arg, "evenLucky") > 0.4
                    println("Did you misspell \"lucky\" or \"evenLucky\"? Check capitalization.\n")
                    helpdisplay()
                else
                    helpdisplay()
                end
            elseif k < 0
                k = -k
                range = true
            end
        elseif pos == 3 || pos == 4 && comma
            if arg == ","
                comma = true
                continue
            elseif arg == "lucky"
                continue
            elseif arg == "evenLucky"
                evenLucky = true
            elseif compare(Hamming(), arg, "lucky") > 0.1 || compare(Hamming(), arg, "evenLucky") > 0.1
                println("Did you misspell "\lucky\" or "\evenLucky\"?\n\n")
                helpdisplay()
            else
                helpdisplay()
            end
        elseif arg == "lucky"
                continue
        elseif arg == "evenLucky"
                evenLucky = true
        else
            println("Too many arguments.\n")
            helpdisplay()
        end
    end
    (j, k, evenLucky, range)
end

function runopts()
    (j, k, evenLucky, range) = parsecommandline()
    if j < 1 || (k != 0 && j >= k)
        throw("Lucky number integer parameters out of range: $(typeof(j)), $j, $(typeof(k)), $k")
    end
    if range
        println(luckyrange(j, k, evenLucky))
    else
        println(luckyindex(j, evenLucky, k))
    end
end

runopts()
