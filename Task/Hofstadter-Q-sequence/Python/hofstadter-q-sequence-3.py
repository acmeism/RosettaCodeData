def q(n):
    l = len(q.seq)
    while l <= n:
        q.seq.append(q.seq[l - q.seq[l - 1]] + q.seq[l - q.seq[l - 2]])
	l += 1
    return q.seq[n]
q.seq = [None, 1, 1]

print("Q(n) for n = [1..10] is:", [q(i) for i in range(1, 11)])
print("Q(1000) =", q(1000))
q(100000)
print("Q(i+1) < Q(i) for i [1..100000] is true %i times." %
      sum([q.seq[i] > q.seq[i + 1] for i in range(1, 100000)]))
