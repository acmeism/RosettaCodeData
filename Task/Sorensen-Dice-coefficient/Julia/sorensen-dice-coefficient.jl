using Multisets

""" convert a phrase into a count of bigram tokens of its words """
function tokenizetext(txt)
    tokens = Multiset{String}()
    words = split(lowercase(txt), r"\s+")
    for w in words
        a = collect(w)
        if length(a) < 3
            push!(tokens, w)
        else
            for i in 1:length(a)-1
                push!(tokens, String(a[i:i+1]))
            end
        end
    end
    return tokens
end

""" Sorenson-Dice similarity of multisets """
function sorenson_dice(text1, text2)
    bc1, bc2 = tokenizetext(text1), tokenizetext(text2)
    return 2 * length(bc1 ∩ bc2) / (length(bc1) + length(bc2))
end

const alltasks = split(read("onedrive/documents/julia programs/tasks.txt", String), "\n")

# run tests
for test in ["Primordial primes", "Sunkist-Giuliani formula",
                 "Sieve of Euripides", "Chowder numbers"]
    taskvalues = sort!([(sorenson_dice(test, t), t) for t in alltasks], rev = true)
    println("\n$test:")
    for (val, task) in taskvalues[begin:begin+4]
        println(lpad(Float16(val), 8), "  ", task)
    end
end

