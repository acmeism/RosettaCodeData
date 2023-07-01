list = ["Now", "is", "the", "time", "for", "all", "good", "men", "to", "come", "to", "the", "aid", "of", "the", "party."]
for i = 1 to len(list)
    for j = i + 1 to len(list)
        if list[i] = list[j] del(list, j) j-- ok
    next
next

for n = 1 to len(list)
    see list[n] + " "
next
see nl
