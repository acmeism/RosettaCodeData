DIM doors(0 TO 99)
FOR pass = 0 TO 99
	FOR door = pass TO 99 STEP pass + 1
		PRINT doors(door)
		PRINT NOT doors(door)
		doors(door) = NOT doors(door)
	NEXT door
NEXT pass
FOR i = 0 TO 99
	PRINT "Door #"; i + 1; " is ";
	IF NOT doors(i) THEN
		PRINT "closed"
	ELSE
		PRINT "open"
	END IF
NEXT i
