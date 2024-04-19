DIM doors(0 TO 99)
FOR door = 0 TO 99
	IF INT(SQR(door)) = SQR(door) THEN doors(door) = -1
NEXT door
FOR i = 0 TO 99
	PRINT "Door #"; i + 1; " is ";
	IF NOT doors(i) THEN
		PRINT "closed"
	ELSE
		PRINT "open"
	END IF
NEXT i
