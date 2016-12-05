a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
shuffle(a)
for n = 1 to len(a)
    see "" + a[n] + " "
next

func shuffle t
     n = len(t)
     while n > 1
           k = random(n-1)+1
           temp = t[n]
           t[n] = t[k]
           t[k] = temp
           n = n - 1
     end
     return t
