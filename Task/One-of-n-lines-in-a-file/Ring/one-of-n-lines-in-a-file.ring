cnt = list(10)
for nr = 1 to 10000
    cnt[oneofn(10)] += 1
next
for m = 1 to 10
    see "" + m + " : " + cnt[m] + nl
next
see nl

func oneofn n
for i = 1 to n
    if random(1) <= 1/i d = i ok
next
return d
