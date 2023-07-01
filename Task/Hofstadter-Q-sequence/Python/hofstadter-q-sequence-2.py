from sys import getrecursionlimit

def q1(n):
    if n < 1 or type(n) != int: raise ValueError("n must be an int >= 1")
    try:
        return q.seq[n]
    except IndexError:
        len_q, rlimit = len(q.seq), getrecursionlimit()
        if (n - len_q) > (rlimit // 5):
            for i in range(len_q, n, rlimit // 5):
                q(i)
        ans = q(n - q(n - 1)) + q(n - q(n - 2))
        q.seq.append(ans)
        return ans

if __name__ == '__main__':
    tmp = q1(100000)
    print("Q(i+1) < Q(i) for i [1..100000] is true %i times." %
          sum(k1 < k0 for k0, k1 in zip(q.seq[1:], q.seq[2:])))
