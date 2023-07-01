prod := 1
sum := 0
x := +5
y := -5
z := -2
one :=  1
three :=  3
seven :=  7

for_J("doTHis", -three, 3**3, three)
for_J("doTHis", -seven, +seven, x)
for_J("doTHis", 555, 550-y)
for_J("doTHis", 22, -28, -three)
for_J("doTHis", 1927, 1939)
for_J("doTHis", x, y, z)
for_J("doTHis", 11**x, 11**x+one)

MsgBox % "sum = " RegExReplace(sum, "\B(?=(\d{3})+$)", ",")
. "`nprod = "  RegExReplace(prod, "\B(?=(\d{3})+$)", ",")
return
;----------------------------------------------
doThis(j){
	global sum, prod
	sum += Abs(j)
	if (Abs(prod) < 2**27) && (j != 0)
		prod *= j
}
return
