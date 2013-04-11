DECLARE FUNCTION getPi! (throws!)
CLS
PRINT getPi(10000)
PRINT getPi(100000)
PRINT getPi(1000000)
PRINT getPi(10000000)

FUNCTION getPi (throws)
	inCircle = 0
		FOR i = 1 TO throws
			'a square with a side of length 2 centered at 0 has
			'x and y range of -1 to 1
			randX = (RND * 2) - 1'range -1 to 1
			randY = (RND * 2) - 1'range -1 to 1
			'distance from (0,0) = sqrt((x-0)^2+(y-0)^2)
			dist = SQR(randX ^ 2 + randY ^ 2)
			IF dist < 1 THEN 'circle with diameter of 2 has radius of 1
				inCircle = inCircle + 1
			END IF
		NEXT i
	getPi = 4! * inCircle / throws
END FUNCTION
