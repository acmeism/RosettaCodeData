""" taken from https://leetcode.com/problems/largest-palindrome-product/discuss/150954/Fast-algorithm-by-constrains-on-tail-digits """

T=[set([(0, 0)])]

def double(it):
    for a, b in it:
        yield a, b
        yield b, a

def tails(n):
    '''Construct pair of n-digit numbers that their product ends with 99...9 pattern'''
    if len(T)<=n:
        l = set()
        for i in range(10):
            for j in range(i, 10):
                I = i*10**(n-1)
                J = j*10**(n-1)
                it = tails(n-1)
                if I!=J: it = double(it)
                for t1, t2 in it:
                    if ((I+t1)*(J+t2)+1)%10**n == 0:
                        l.add((I+t1, J+t2))
        T.append(l)
    return T[n]

def largestPalindrome(n):
    """ find largest palindrome that is a product of two n-digit numbers """
    m, tail = 0, n // 2
    head = n - tail
    up = 10**head
    for L in range(1, 9*10**(head-1)+1):
        # Consider small shell (up-L)^2 < (up-i)*(up-j) <= (up-L)^2, 1<=i<=L<=j
        m = 0
        sol = None
        for i in range(1, L + 1):
            lo = max(i, int(up - (up - L + 1)**2 / (up - i)) + 1)
            hi = int(up - (up - L)**2 / (up - i))
            for j in range(lo, hi + 1):
                I = (up-i) * 10**tail
                J = (up-j) * 10**tail
                it = tails(tail)
                if I!=J: it = double(it)
                    for t1, t2 in it:
                        val = (I + t1)*(J + t2)
                        s = str(val)
                        if s == s[::-1] and val>m:
                            sol = (I + t1, J + t2)
                            m = val

        if m:
            print("{:2d}\t{:4d}".format(n, m % 1337), sol, sol[0] * sol[1])
            return m % 1337
    return 0

if __name__ == "__main__":
    for k in range(1, 14):
        largestPalindrome(k)
