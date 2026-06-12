nr=0
num = 0
sum = 0
Table = []

see "The first 50 inconsummate numbers:" + nl + nl

while num < 100000
	num++
    sum = 0
	cStr = string(num)
	for n = 1 to len(cStr)
		sum += number(cStr[n])
	next
	if num%sum = 0
		m = num/sum
		add(Table,m)
	ok
end

lin = 0
m = 1
nr = 0

while nr < 50
   m = m + 1
   if not find(Table,m)
      nr = nr + 1
	  see "" + m + " "
	  lin = lin + 1
   	  if lin%5 = 0
         see nl
	  ok
    ok
end
