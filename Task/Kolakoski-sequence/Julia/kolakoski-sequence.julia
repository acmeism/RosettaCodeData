function kolakoski(vec, len)
    seq = Vector{Int}()
    k = 0
    denom = length(vec)
    while length(seq) < len
        n = vec[k % denom + 1]
        k += 1
        seq = vcat(seq, repeat([n], k > length(seq) ? n : seq[k]))
    end
    seq[1:len]
end

function iskolakoski(seq)
    count = 1
    rle = Vector{Int}()
    for i in 2:length(seq)
        if seq[i] == seq[i - 1]
            count += 1
        else
            push!(rle, count)
            count = 1
        end
    end
    rle == seq[1:length(rle)]
end

const tests = [[[1, 2], 20],[[2, 1] ,20], [[1, 3, 1, 2], 30], [[1, 3, 2, 1], 30]]

for t in tests
    vec, n = t[1], t[2]
    seq = kolakoski(vec, n)
    println("Kolakoski from $(vec): first $n numbers are $seq.")
    println("\t\tDoes this look like a Kolakoski sequence? ", iskolakoski(seq) ? "Yes" : "No")
end
