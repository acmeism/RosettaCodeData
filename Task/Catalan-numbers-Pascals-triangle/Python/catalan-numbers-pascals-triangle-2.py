def catalan_number(n):
    nm = dm = 1
    for k in range(2, n+1):
      nm, dm = ( nm*(n+k), dm*k )
    return nm/dm

print [catalan_number(n) for n in range(1, 16)]

[1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845]
