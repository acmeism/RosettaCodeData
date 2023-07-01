n = 41
k=3
see "n =" + n + " k = " + k + " final survivor = " + josephus(n, k, 0) + nl

func josephus (n, k, m)
lm = m
for a = m+1  to n
     lm = (lm+k) % a
next
josephus = lm
return josephus
