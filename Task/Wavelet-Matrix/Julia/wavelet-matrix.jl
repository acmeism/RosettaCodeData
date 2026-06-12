""" rosettacode.org/wiki/Wavelet_Matrix """

""" A block of bits, within an Int vector, and their ranks """
mutable struct BitRank
    block::Vector{UInt64}
    count::Vector{UInt64}
    BitRank(num) = (n = (num + 1) >> 6 + 1; new(zeros(UInt64, n), zeros(UInt64, n)))
end

""" Set bit at position i """
function set!(br::BitRank, i, val)
    br.block[i>>6+1] |= (val << (i & 63))
end

""" Build the rank structure """
function build!(br::BitRank)
    for i in 2:length(br.block)
        br.count[i] = br.count[i-1] + popcountll(br.block[i-1])
    end
end

""" Count number of 1's in an integer (popcount equivalent) """
function popcountll(n)
    count = 0
    while n != 0
        count += n & 1
        n >>= 1
    end
    return count
end

""" Count number of 1's in [0, i) """
function rank1(br::BitRank, i)
    block_idx = i >> 6 + 1
    br.count[block_idx] + popcountll(br.block[block_idx] & ((1 << (i & 63)) - 1))
end

""" Count number of 1's in [i, j) """
rank1FromTo(br::BitRank, i, j) = rank1(br, j) - rank1(br, i)

""" Count number of 0's in [0, i) """
rank0(br::BitRank, i) = i - rank1(br, i)

""" Count number of 0's in [i, j) """
rank0FromTo(br::BitRank, i, j) = rank0(br, j) - rank0(br, i)

""" Wavelet object with bit rankings """
mutable struct WaveletMatrix
    height::Int
    B::Vector{BitRank}
    pos::Vector{Int}
end
function WaveletMatrix(vec::Vector{Int}, sigma = nothing)
    isnothing(sigma) && (sigma = maximum(vec) + 1)
    len = length(vec)
    # Calculate height based on sigma value
    height = sigma == 1 ? 1 : 65 - ndigits(sigma - 1, base = 2)
    wm = WaveletMatrix(height, BitRank[], Int[])
    for i in 1:wm.height
        push!(wm.B, BitRank(len))
        for j in 1:len
            set!(wm.B[i], j - 1, getbit(vec[j], wm.height - i))
        end
        build!(wm.B[i])
        # Stable partition - separate 0's and 1's while preserving order
        push!(wm.pos, stable_partition!(vec, c -> getbit(c, wm.height - i) == 0))
    end
    return wm
end

""" Stable partition implementation """
function stable_partition!(arr::Vector{Int}, predicate)
    result = Int[]
    false_values = Int[]
    for item in arr
        if predicate(item)
            push!(result, item)
        else
            push!(false_values, item)
        end
    end
    partition_point = length(result)
    append!(result, false_values)
    # Update the original array
    copyto!(arr, result)
    return partition_point
end

""" Get bit at position i from val """
getbit(val, i) = (val >> i) & 1

""" Count occurrences of val in range [l, r) """
function rank(wm::WaveletMatrix, val, l, r = nothing)
    isnothing(r) && return rank_single(wm, val, l)
    return rank_single(wm, val, r) - rank_single(wm, val, l)
end

""" Count occurrences of val in range [0, i) """
function rank_single(wm::WaveletMatrix, val, i)
    p = 0
    for j in 1:wm.height
        if getbit(val, wm.height - j)
            p = wm.pos[j] + rank1(wm.B[j], p)
            i = wm.pos[j] + rank1(wm.B[j], i)
        else
            p = rank0(wm.B[j], p)
            i = rank0(wm.B[j], i)
        end
    end
    return i - p
end

""" kth smallest element in [l, r) """
function quantile(wm::WaveletMatrix, k, l, r)
    res = 0
    for i in 1:wm.height
        j = rank0FromTo(wm.B[i], l, r)
        if j > k
            l = rank0(wm.B[i], l)
            r = rank0(wm.B[i], r)
        else
            l = Int(wm.pos[i] + rank1(wm.B[i], l))
            r = Int(wm.pos[i] + rank1(wm.B[i], r))
            k -= j
            res |= (1 << (wm.height - i))
        end
    end
    return res
end

""" Count elements in [l, r) that are in value range [a, b) """
function rangefreq(wm::WaveletMatrix, l, r, a, b)
    return rangefreq_recursive(wm, l, r, a, b, 0, 1 << wm.height, 0)
end
function rangefreq_recursive(wm::WaveletMatrix, i, j, a, b, l, r, x)
    if i == j || r <= a || b <= l
        return 0
    end
    mid = (l + r) >> 1
    if a <= l && r <= b
        return j - i
    end
    left = rangefreq_recursive(wm, rank0(wm.B[x+1], i), rank0(wm.B[x+1], j), a, b, l, mid, x + 1)
    right = rangefreq_recursive(wm, wm.pos[x+1] + rank1(wm.B[x+1], i), wm.pos[x+1] + rank1(wm.B[x+1], j), a, b, mid, r, x + 1)
    return left + right
end

""" Find minimum value in [l, r) within value range [a, b), -1 if not found """
function rangemin(wm::WaveletMatrix, l, r, a, b)
    rangemin_recursive(wm, l, r, a, b, 0, 1 << wm.height, 0, 0)
end
function rangemin_recursive(wm::WaveletMatrix, i, j, a, b, l, r, x, val)
    (i == j || r <= a || b <= l) && return -1
    r - l == 1 && return val
    mid = (l + r) >> 1
    res = rangemin_recursive(wm, rank0(wm.B[x+1], i), rank0(wm.B[x+1], j), a, b, l, mid, x + 1, val)
    return res < 0 ?
           rangemin_recursive(wm, wm.pos[x+1] + rank1(wm.B[x+1], i), wm.pos[x+1] + rank1(wm.B[x+1], j), a, b, mid, r, x + 1, val + (1 << (wm.height - x - 1))) :
           res
end

""" test the wavelet matrix """
function main()
    a = [3374, 956, 2114, 3415, 3437]
    unique_a = unique!(sort(a))
    input = [findfirst(==(x), unique_a) - 1 for x in a]
    wm = WaveletMatrix(input)

    lrk_vector = [[2, 2, 1], [3, 4, 1], [4, 5, 1], [1, 2, 2], [4, 4, 1]]

    for (l, r, k) in lrk_vector
        println(unique_a[quantile(wm, k - 1, l - 1, r)+1])
    end
end

# Execute the main function
main()
