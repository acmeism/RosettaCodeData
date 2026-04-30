? "Write a routine (subroutine, function, procedure, whatever it may be called in your language) to test if a number is a colorful number or not."
p = 0
num1 = 24753
num2 = 2346
Table = []

color(num1)

func color(num)
   ? "num = " + num
   ? "----------------"
	snum = string(num)
	for n = 1 to len(snum)
		for m = 1 to 5
         proc = 1
         rep = len(snum)-m
			for z = 0 to rep
				p = substr(snum,n+z,m)
            proc = p[m] * proc
            fac = fact(p)
            add(Table,proc)
            if p = num
               exit 3
            ok
			next
		next
	next
	? "----------------"	

	STable = sort(Table)
	flag = 1
	for x = 1 to len(STable)-1
		if STable[x] = STable[x+1]
			flag = 0
			exit
		ok
	next

	if flag = 1
   	? "" + num + " is colorful number"
		? "----------------"
	else
   	? "" + num + " is not colorful number"
		? "----------------"
	ok

func fact(p)
   fct = ""
   fcp = 1
	for n = 1 to len(p)
		fct += p[n] + "x"
      fcp = fcp * p[n]
	next
   fct = left(fct,len(fct)-1)
   ? fct + " = " + fcp
