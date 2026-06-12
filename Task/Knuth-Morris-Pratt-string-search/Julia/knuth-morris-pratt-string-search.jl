"""
    function kmp_table(W)

input:
    an array of characters, W (the word to be analyzed)
output:
    an array of integers, T (the table to be filled)
define variables:
    an integer, i ← 2 (the current one-based position we are computing in T)
    an integer, j ← 0 (the additive to index i in W of the next character of the current candidate substring)
"""
function kmp_table(W)
    len = length(W)
    T = zeros(Int, len)
    # start with the second letter of W, looking for patterns in W
    i = 2
    while i < len
        j = 0
        while i + j <= len # avoid overshooting end with index
            # compute the longest proper prefix
            if W[i + j] == W[j + 1]
                T[i + j] = T[i + j - 1] + 1
            else
                T[i + j] = 0 # back to start
                j += 1
                break
            end
            j += 1
        end
        # entry in T found, so begin at next starting point along W
        i += j
    end
    return T
end

"""
    function kmp_search(S, W)

input:
    an array of characters, S (the text to be searched)
    an array of characters, W (the word sought)
output:
    an array of integers, P (positions in S at which W is found)

define variables (one based indexing in Julia differs from the Wikipedia example):
    an integer, i ← 1 (the position of the current character in S)
    an integer, j ← 1 (the position of the current character in W)
    an array of integers, T (the table, computed elsewhere)
"""
function kmp_search(S, W)
    lenW, lenS = length(W), length(S)
    i, P = 1, Int[]
    T = kmp_table(W) # get pattern table
    while i <= lenS - lenW + 1
        for j in 1:lenW
            if S[i + j - 1] != W[j]
                # pattern not found, so skip unnecessary inner loops
                i += T[j] + 1
                @goto next_outer_loop
            end
        end
        # found pattern W in S, so add to output P
        push!(P, i)
        i += 1
        @label next_outer_loop
    end
    return P
end

const text1 = "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented"
const text2 = "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
const pat1, pat2, pat3 = "put", "and", "alfalfa"

println("Found <$pat1> at: (one-based indices) ", kmp_search(text1, pat1))
println("Found <$pat2> at: (one-based indices) ", kmp_search(text1, pat2))
println("Found <$pat3> at: (one-based indices) ", kmp_search(text2, pat3))
