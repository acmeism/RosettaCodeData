Load "stdlibcore.ring"

nr = 0
num = 0
sig1 = 0
cmp = 0

see "FIRST 50 DUFFINIAN NUMBERS:" + nl

while nr < 50
	num = num + 1
	sigma = 0
	cmp = comp(num)
	if cmp = 1
		sgm = sigm1(num)
      relat1prim()
	ok
end

nr = 0
fok = 0
numc = 1
sig1 = 0
sig2 = 0
sig3 = 0

see nl + "FIRST 15 DUFFINIAN TRIPLETS:" + nl

while nr < 15

   num1 = numc
   num2 = num1 + 1
   num3 = num2 + 1
	cmp1 = comp(num1)
	cmp2 = comp(num2)
	cmp3 = comp(num3)
	if (cmp1 = 1) and (cmp2 = 1) and (cmp3 = 1)
		sigm1(num1)
		sigm2(num2)
		sigm3(num3)
	ok
	numc = numc + 1
end

func comp(nm)
	fok = 0
	flag = 0
   for n = 1 to nm
		if nm%n = 0
			flag = flag + 1
		ok
		if flag > 2
      	fok = 1
			exit
		ok
	next
   return fok

func sigm1(num1)
	sig1 = 0
	for n = 1 to num1
		if num1%n = 0
			sig1 = sig1 + n
		ok
   next

func sigm2(num2)
	sig2 = 0
	for n = 1 to num2
		if num2%n = 0
			sig2 = sig2 + n
		ok
   next

func sigm3(num3)
	sig3 = 0
	for n = 1 to num3
		if num3%n = 0
			sig3 = sig3 + n
		ok
   next

	relat2prim()

func relat1prim()
	if (gcd(num,sig1) = 1)
      nr = nr + 1
		see "" + num + " "
	ok
   return nr

func relat2prim()
	if ((gcd(num1,sig1) = 1) and (gcd(num2,sig2) = 1) and (gcd(num3,sig3) = 1))
      nr = nr + 1
		see "" + num1 + "-" + num3 + " "
	ok
   return nr
