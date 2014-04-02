import collections
s= collections.deque(maxlen=55)
#    Start with a single seed in range 0 to 10**9 - 1.
seed = 292929

#    Set s0 = seed and s1 = 1.
#    The inclusion of s1 = 1 avoids some bad states
#    (like all zeros, or all multiples of 10).
s.append(seed)
s.append(1)

#    Compute s2,s3,...,s54 using the subtractive formula
#    sn = s(n - 2) - s(n - 1)(mod 10**9).
for n in xrange(2, 55):
    s.append((s[n-2] - s[n-1]) % 10**9)

#    Reorder these 55 values so r0 = s34, r1 = s13, r2 = s47, ...,
#                               rn = s(34 * (n + 1)(mod 55)).

r = collections.deque(maxlen=55)
for n in xrange(55):
    i = (34 * (n+1)) % 55
    r.append(s[i])
#        This is the same order as s0 = r54, s1 = r33, s2 = r12, ...,
#                                  sn = r((34 * n) - 1(mod 55)).
#        This rearrangement exploits how 34 and 55 are relatively prime.
#    Compute the next 165 values r55 to r219. Store the last 55 values.


def getnextr():
    """get next random number"""
    r.append((r[0]-r[31])%10**9)
    return r[54]

# rn = r(n - 55) - r(n - 24)(mod 10**9) for n >= 55
for n in xrange(219 - 54):
    getnextr()

# now fully initilised
# print first five numbers
for i in xrange(5):
    print "result = ", getnextr()
