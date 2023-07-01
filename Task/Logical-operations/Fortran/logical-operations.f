       SUBROUTINE PRNLOG(A, B)
       LOGICAL A, B
       PRINT *, 'a and b is ', A .AND. B
       PRINT *, 'a or b is ', A .OR. B
       PRINT *, 'not a is ', .NOT. A

C       You did not ask, but the following logical operators are also standard
C       since ANSI FORTRAN 66
C       =======================================================================

C       This yields the same results as .EQ., but has lower operator precedence
C       and only works with LOGICAL operands:
       PRINT *, 'a equivalent to b is ', A .EQV. B

C       This yields the same results as .NE., but has lower operator precedence
C       and only works with LOGICAL operands (this operation is also commonly
C       called "exclusive or"):
       PRINT *, 'a not equivalent to b is ', A .NEQV. B
       END
