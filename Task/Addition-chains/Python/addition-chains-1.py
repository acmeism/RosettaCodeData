def prepend(n, seq):
    return [n] + seq

def check_seq(pos, seq, n, min_len):
    if pos > min_len or seq[0] > n:
        return min_len, 0
    if seq[0] == n:
        return pos, 1
    if pos < min_len:
        return try_perm(0, pos, seq, n, min_len)
    return min_len, 0

def try_perm(i, pos, seq, n, min_len):
    if i > pos:
        return min_len, 0

    res1 = check_seq(pos + 1, prepend(seq[0] + seq[i], seq), n, min_len)
    res2 = try_perm(i + 1, pos, seq, n, res1[0])

    if res2[0] < res1[0]:
        return res2
    if res2[0] == res1[0]:
        return res2[0], res1[1] + res2[1]
    raise Exception("try_perm exception")

def init_try_perm(x):
    return try_perm(0, 0, [1], x, 12)

def find_brauer(num):
    res = init_try_perm(num)
    print
    print "N = ", num
    print "Minimum length of chains: L(n) = ", res[0]
    print "Number of minimum length Brauer chains: ", res[1]

# main
nums = [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]
for i in nums:
    find_brauer(i)
