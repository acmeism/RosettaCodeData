' Chinese zodiac - VBS

Animals  = array( "Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig" )
Elements = array( "Wood","Fire","Earth","Metal","Water" )
YinYang  = array( "Yang","Yin" )
Years    = array( 1935, 1938, 1968, 1972, 1976, 1984, 2017 )

for i = LBound(Years) to UBound(Years)
	xYear    = Years(i)
	yElement = Elements(((xYear - 4) mod 10) \ 2)
	yAnimal  = Animals(  (xYear - 4) mod 12     )
	yYinYang = YinYang(   xYear      mod  2     )
	nn       =          ((xYear - 4) mod 60) + 1
	msgbox xYear & " is the year of the " & yElement & " " &  yAnimal & " (" &  yYinYang & ").",, _
		   xYear & " : " & nn & "/60"
next
