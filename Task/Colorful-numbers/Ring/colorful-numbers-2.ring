p = 0
lin = 1
Table = []

? "All of the colorful numbers less than 100:"

for nm = 1 to 100
	color(nm)
next

func color(num)

	Table = []
	snum = string(num)
	for n = 1 to len(snum)
		for m = 1 to 5
         proc = 1
         rep = len(snum)-m
			for z = 0 to rep
				p = substr(snum,n+z,m)
            proc = p[m] * proc
            add(Table,proc)
            if p = num
               exit 3
            ok
			next
		next
	next

	STable = sort(Table)
	flag = 1
	for x = 1 to len(STable)-1
		if STable[x] = STable[x+1]
			flag = 0
			exit
		ok
	next

	if flag = 1
		if lin % 5 = 0
         ? "" + num
		else
      	see "" + num + " "
		ok
		lin++
	ok
