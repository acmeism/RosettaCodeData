def check_seq(pos, seq, n, min_len)
    if pos > min_len or seq[0] > n then
        return min_len, 0
    elsif seq[0] == n then
        return pos, 1
    elsif pos < min_len then
        return try_perm(0, pos, seq, n, min_len)
    else
        return min_len, 0
    end
end

def try_perm(i, pos, seq, n, min_len)
    if i > pos then
        return min_len, 0
    end

    res11, res12 = check_seq(pos + 1, [seq[0] + seq[i]] + seq, n, min_len)
    res21, res22 = try_perm(i + 1, pos, seq, n, res11)

    if res21 < res11 then
        return res21, res22
    elsif res21 == res11 then
        return res21, res12 + res22
    else
        raise "try_perm exception"
    end
end

def init_try_perm(x)
    return try_perm(0, 0, [1], x, 12)
end

def find_brauer(num)
    actualMin, brauer = init_try_perm(num)
    puts
    print "N = ", num, "\n"
    print "Minimum length of chains: L(n)= ", actualMin, "\n"
    print "Number of minimum length Brauer chains: ", brauer, "\n"
end

def main
    nums = [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]
    for i in nums do
        find_brauer(i)
    end
end

main()
