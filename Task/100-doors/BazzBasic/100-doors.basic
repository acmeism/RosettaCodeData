' ============================================
' 100 DOORS - BazzBasic Edition
' https://rosettacode.org/wiki/100_doors
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' 100 doors, all closed. 100 passes:
' Pass N toggles every Nth door.
' Which doors are open after all passes?
' ============================================

[inits]
	LET DOORS# = 100
	DIM door$

	' Initialize all doors to 0 (closed)
	FOR d$ = 1 TO DOORS#
		door$(d$) = 0
	NEXT


[simulate]
	FOR pass$ = 1 TO DOORS#
		FOR d$ = pass$ TO DOORS# STEP pass$
			door$(d$) = 1 - door$(d$)
		NEXT
	NEXT


[report]
	CLS
	PRINT "100 Doors — rosettacode.org/wiki/100_doors"
	PRINT REPEAT("=", 44)
	PRINT ""
	PRINT "Open doors after all 100 passes:"
	PRINT ""

	LET count$ = 0
	FOR d$ = 1 TO DOORS#
		IF door$(d$) = 1 THEN
			PRINT "  Door "; d$
			count$ = count$ + 1
		END IF
	NEXT

	PRINT ""
	PRINT REPEAT("-", 44)
	PRINT count$; " doors open  (the perfect squares 1..100)"
	PRINT ""
	PRINT "Press any key...";
	WAITKEY()
END
