function index(a,i)
    return a[i + 1]
end

function checkSeq(pos, seq, n, minLen)
    if pos > minLen or index(seq,0) > n then
        return minLen, 0
    elseif index(seq,0) == n then
        return pos, 1
    elseif pos < minLen then
        return tryPerm(0, pos, seq, n, minLen)
    else
        return minLen, 0
    end
end

function tryPerm(i, pos, seq, n, minLen)
    if i > pos then
        return minLen, 0
    end

    local seq2 = {}
    table.insert(seq2, index(seq,0) + index(seq,i))
    for j=1,table.getn(seq) do
        table.insert(seq2, seq[j])
    end
    local res1a, res1b = checkSeq(pos + 1, seq2, n, minLen)
    local res2a, res2b = tryPerm(i + 1, pos, seq, n, res1a)

    if res2a < res1a then
        return res2a, res2b
    elseif res2a == res1a then
        return res2a, res1b + res2b
    else
        error("tryPerm exception")
    end
end

function initTryPerm(x)
    local seq = {}
    table.insert(seq, 1)
    return tryPerm(0, 0, seq, x, 12)
end

function findBrauer(num)
    local resa, resb = initTryPerm(num)
    print()
    print("N = " .. num)
    print("Minimum length of chains: L(n) = " .. resa)
    print("Number of minimum length Brauer chains: " .. resb)
end

function main()
    findBrauer(7)
    findBrauer(14)
    findBrauer(21)
    findBrauer(29)
    findBrauer(32)
    findBrauer(42)
    findBrauer(64)
    findBrauer(47)
    findBrauer(79)
    findBrauer(191)
    findBrauer(382)
    findBrauer(379)
end

main()
