using DataStructures # for deque

const seed = "Four is the number of letters in the first word of this sentence, "
const (word2, word3) = ("in", "the")

lettercount(w) = length(w) -  length(collect(eachmatch(r"-", w)))
splits(txt) = [x.match for x in eachmatch(r"[\w\-]+", txt)]
todq(sentence) = (d = Deque{String}(); map(x->push!(d, x), splits(sentence)[2:end]); d)

struct CountLetters
    seedsentence::String
    words::Deque{String}
    commasafter::Vector{Int}
    CountLetters(s) = new(s, todq(s), [13])
    CountLetters() = CountLetters(seed)
end

function Base.iterate(iter::CountLetters, state = (1, 5, ""))
    if length(iter.words) < 1
        return nothing
    end
    returnword = popfirst!(iter.words)
    nextwordindex = state[1] + 1
    wordlen = lettercount(returnword)
    wordvec = vcat(num2text(wordlen), word2, word3, splits(numtext2ordinal(num2text(nextwordindex))))
    map(x -> push!(iter.words, x), wordvec)
    push!(iter.commasafter, length(iter.words))
    added = length(returnword) + (nextwordindex in iter.commasafter ? 2 : 1)
    (wordlen, (nextwordindex, state[2] + added, returnword))
end

Base.eltype(iter::CountLetters) = Int

function firstN(n = 201)
    countlet = CountLetters()
    print("It is interesting how identical lengths align with 20 columns.\n   1:   4")
    iter_result = iterate(countlet)
    itercount = 2
    while iter_result != nothing
        (wlen, state) = iter_result
        print(lpad(string(wlen), 4))
        if itercount % 20 == 0
            print("\n", lpad(itercount+1, 4), ":")
        elseif itercount >= n
            break
        end
        iter_result = iterate(countlet, state)
        itercount += 1
    end
    println()
end

function sumwords(iterations)
    countlet = CountLetters()
    iter_result = iterate(countlet)
    itercount = 2
    while iter_result != nothing
        (wlen, state) = iter_result
        if itercount == iterations
            return state
        end
        iter_result = iterate(countlet, state)
        itercount += 1
    end
    throw("Iteration failed on \"Four is the number\" task.")
end

firstN()

for n in [2202, 1000, 10000, 100000, 1000000, 10000000]
    (itercount, totalletters, lastword) = sumwords(n)
    println("$n words -> $itercount iterations, $totalletters letters total, ",
            "last word \"$lastword\" with $(length(lastword)) letters.")
end
