-- Return the base two logarithm of x
function log2 (x) return math.log(x) / math.log(2) end

-- Return the Shannon entropy of X
function entropy (X)
    local N, count, sum, i = X:len(), {}, 0
    for char = 1, N do
        i = X:sub(char, char)
        if count[i] then
            count[i] = count[i] + 1
        else
            count[i] = 1
        end
    end
    for n_i, count_i in pairs(count) do
        sum = sum + count_i / N * log2(count_i / N)
    end
    return -sum
end

-- Return a table of the first n Fibonacci words
function fibWords (n)
    local fw = {1, 0}
    while #fw < n do fw[#fw + 1] = fw[#fw] .. fw[#fw - 1] end
    return fw
end

-- Main procedure
print("n\tWord length\tEntropy")
for k, v in pairs(fibWords(37)) do
    v = tostring(v)
    io.write(k .. "\t" .. #v)
    if string.len(#v) < 8 then io.write("\t") end
    print("\t" .. entropy(v))
end
