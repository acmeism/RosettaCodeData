PROGRAM TOWER

  CALL Move(4, 1, 2, 3)

CONTAINS

  RECURSIVE SUBROUTINE Move(ndisks, from, to, via)
    INTEGER, INTENT (IN) :: ndisks, from, to, via

    IF (ndisks == 1) THEN
       WRITE(*, "(A,I1,A,I1)") "Move disk from pole ", from, " to pole ", to
    ELSE
       CALL Move(ndisks-1, from, via, to)
       CALL Move(1, from, to, via)
       CALL Move(ndisks-1, via, to, from)
    END IF
  END SUBROUTINE Move

END PROGRAM TOWER
