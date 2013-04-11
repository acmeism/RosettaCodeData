Arith(first,second)	; Mathematical operators
	Write "Plus",?12,first,"+",second,?25," = ",first+second,!
	Write "Minus",?12,first,"-",second,?25," = ",first-second,!
	Write "Multiply",?12,first,"*",second,?25," = ",first*second,!
	Write "Divide",?12,first,"/",second,?25," = ",first/second,!
	Write "Int Divide",?12,first,"\",second,?25," = ",first\second,!
	Write "Power",?12,first,"**",second,?25," = ",first**second,!
	Write "Modulo",?12,first,"#",second,?25," = ",first#second,!
	Write "And",?12,first,"&",second,?25," = ",first&second,!
	Write "Or",?12,first,"!",second,?25," = ",first!second,!
	Quit

Do Arith(2,3)
Plus        2+3           = 5
Minus       2-3           = -1
Multiply    2*3           = 6
Divide      2/3           = .6666666666666666667
Int Divide  2\3           = 0
Power       2**3          = 8
Modulo      2#3           = 2
And         2&3           = 1
Or          2!3           = 1

Do Arith(16,0.5)
Plus        16+.5         = 16.5
Minus       16-.5         = 15.5
Multiply    16*.5         = 8
Divide      16/.5         = 32
Int Divide  16\.5         = 32
Power       16**.5        = 4
Modulo      16#.5         = 0
And         16&.5         = 1
Or          16!.5         = 1

Do Arith(0,2)
Plus        0+2           = 2
Minus       0-2           = -2
Multiply    0*2           = 0
Divide      0/2           = 0
Int Divide  0\2           = 0
Power       0**2          = 0
Modulo      0#2           = 0
And         0&2           = 0
Or          0!2           = 1
