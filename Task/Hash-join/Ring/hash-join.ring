Table1 = [[27, "Jonah"], [18, "Alan"], [28, "Glory"], [18, "Popeye"], [28, "Alan"]]
Table2 = [["Jonah", "Whales"], ["Jonah", "Spiders"], ["Alan", "Ghosts"], ["Alan", "Zombies"], ["Glory", "Buffy"]]
hTable = []
Qtable = []

for a in table1
	h = hashing(a[2])
	add(htable,[h , a])
next

for b in table2
	h = hashing(b[1])
	for sh in htable
		if sh[1] = h
			 add(qtable, sh[2] + b[2])
		ok
	next
next

print(qtable)

#===============End of Execution=========

func print lst
see "---------------------------------------------------
Age	| Name		|| Name		| Nemesis
---------------------------------------------------
"
for l in lst
	see string(l[1]) + char(9) + "| " + l[2] + copy(char(9),2) + "|| " + l[2] + "    " + char(9) +  "| " + l[3] + nl
next

func Hashing str
r = 0
if len(str) > 4
	r = (ascii(str[1]) + ascii(str[len(str)]) + ascii(str[ceil(len(str) * 0.25)]) + ascii(str[ceil(len(str) * 0.75)]))
else
	for s in str
		r += ascii(s)
	next
ok
return r
