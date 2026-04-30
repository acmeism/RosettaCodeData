p = 0
flag = 0
Table = []

? "The largest possible colorful number:"

for nm = 98746255 to 98746235  step -1
	color(nm)
	if flag = 1
		? nm
	ok

next

func color(num)
   lin = 0
	Table = []
	snum = string(num)
	for n = 1 to len(snum)
		for m = 1 to 8
         proc = 1
         rep = len(snum)-m
			for z = 0 to rep
				p = substr(snum,n+z,m)
            proc = p[m] * proc
            if p[m] = num
            	fac = fact(p)
				ok
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

func fact(p)
   fct = ""
   fcp = 1
	for n = 1 to len(p)
		fct += p[n] + "x"
      fcp = fcp * p[n]
	next
   fct = left(fct,len(fct)-1)
   ? fct + " = " + fcp
