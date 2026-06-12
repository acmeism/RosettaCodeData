function nextword(n, w, alphabet)
    x = (w ^ ((n ÷ length(w)) + 1))[begin:n]
    while x != "" && x[end] == alphabet[end]
        x = x[begin:end-1]
    end
    if x != ""
        last_char = x[end]
        next_char_index = something(findfirst(==(last_char), alphabet), 0) + 1
        x = x[begin:end-1] * alphabet[next_char_index]
    end
    return x
end

function generate_lyndon_words(n, alphabet)
    lwords = String[]
    w = string(alphabet[begin])
    while length(w) <= n
        push!(lwords, w)
        w = nextword(n, w, alphabet)
        w == "" && break
    end
    return lwords
end

const lyndon_words = generate_lyndon_words(5, "01")
foreach(println, lyndon_words)
