PROGRAM TOWER2

  CALL Move(4, 1, 2, 3)

CONTAINS

  RECURSIVE SUBROUTINE Move(ndisks, from, via, to)
    INTEGER, INTENT (IN) :: ndisks, from, via, to

    IF (ndisks > 1) THEN
       CALL Move(ndisks-1, from, to, via)
       WRITE(*, "(A,I1,A,I1,A,I1)") "Move disk ", ndisks, "  from pole ", from, " to pole ", to
       Call Move(ndisks-1,via,from,to)
    ELSE
       WRITE(*, "(A,I1,A,I1,A,I1)") "Move disk ", ndisks, "  from pole ", from, " to pole ", to
    END IF
  END SUBROUTINE Move

END PROGRAM TOWER2
