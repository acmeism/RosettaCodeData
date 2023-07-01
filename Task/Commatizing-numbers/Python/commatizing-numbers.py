import re as RegEx


def Commatize( _string, _startPos=0, _periodLen=3, _separator="," ):
	outString = ""
	strPos = 0
	matches = RegEx.findall( "[0-9]*", _string )

	for match in matches[:-1]:
		if not match:
			outString += _string[ strPos ]
			strPos += 1
		else:
			if len(match) > _periodLen:
				leadIn = match[:_startPos]
				periods =  [ match [ i:i + _periodLen ] for i in range ( _startPos, len ( match ), _periodLen ) ]
				outString += leadIn + _separator.join( periods )
			else:
				outString += match

			strPos += len( match )

	return outString



print ( Commatize( "pi=3.14159265358979323846264338327950288419716939937510582097494459231", 0, 5, " " ) )
print ( Commatize( "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", 0, 3, "." ))
print ( Commatize( "\"-in Aus$+1411.8millions\"" ))
print ( Commatize( "===US$0017440 millions=== (in 2000 dollars)" ))
print ( Commatize( "123.e8000 is pretty big." ))
print ( Commatize( "The land area of the earth is 57268900(29% of the surface) square miles." ))
print ( Commatize( "Ain't no numbers in this here words, nohow, no way, Jose." ))
print ( Commatize( "James was never known as 0000000007" ))
print ( Commatize( "Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe." ))
print ( Commatize( "␢␢␢$-140000±100 millions." ))
print ( Commatize( "6/9/1946 was a good year for some." ))
