function getFile (filename)
    local inFile = io.open(filename, "r")
    local fileContent = inFile:read("*all")
    inFile:close()
    return fileContent
end

function log2 (x) return math.log(x) / math.log(2) end

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

print(entropy(getFile(arg[0])))
