SUB move (n AS Integer, fromPeg AS Integer, toPeg AS Integer, viaPeg AS Integer)
    IF n>0 THEN
        move n-1, fromPeg, viaPeg, toPeg
        PRINT "Move disk from "; fromPeg; " to "; toPeg
        move n-1, viaPeg, toPeg, fromPeg
    END IF
END SUB

move 4,1,2,3
