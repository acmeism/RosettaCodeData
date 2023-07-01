      MODULE EXAMPLE
       CONTAINS
        SUBROUTINE ABOUND(A)
         CHARACTER*(*) A(:)	!One dimensional array, unspecified bounds.
          WRITE (6,*) "Lower bound",LBOUND(A),", Upper bound",UBOUND(A)
          WRITE (6,*) "Element size",LEN(A(LBOUND(A)))
          WRITE (6,*) A
        END SUBROUTINE ABOUND
      END MODULE EXAMPLE

      PROGRAM SHOWBOUNDS
       USE EXAMPLE
       CHARACTER*6 ARRAY(-1:1)
        ARRAY(-1) = "Apple"
        ARRAY(0) = "Orange"
        ARRAY(1) = ""
        CALL ABOUND(ARRAY)
        WRITE (6,*) "But, when it is at home..."
        WRITE (6,*) "L. bound",LBOUND(ARRAY),", U. bound",UBOUND(ARRAY)
      END
