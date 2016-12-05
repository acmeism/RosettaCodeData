      SUBROUTINE CHECK(A,N)	!Inspect matrix A.
       REAL A(:,:)	!The matrix, whatever size it is.
       INTEGER N	!The order.
       REAL B(N,N)	!A scratchpad, size known on entry..
       INTEGER, ALLOCATABLE::TROUBLE(:)	!But for this, I'll decide later.
       INTEGER M

        M = COUNT(A(1:N,1:N).LE.0)	!Some maximum number of troublemakers.

        ALLOCATE (TROUBLE(1:M**3))	!Just enough.

        DEALLOCATE(TROUBLE)		!Not necessary.
      END SUBROUTINE CHECK		!As TROUBLE is declared within CHECK.
