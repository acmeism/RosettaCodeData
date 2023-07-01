      MODULE ARRAYMUSH	!A rather small collection.
       CONTAINS		!For the specific problem only.
        SUBROUTINE KPRODUCT(A,B,AB)	!AB = Kronecker product of A and B, both two-dimensional arrays.
Considers the arrays to be addressed as A(row,column), despite any storage order arrangements.        .
Creating array AB to fit here, adjusting the caller's array AB, may not work on some compilers.
         INTEGER A(:,:),B(:,:)		!Two-dimensional arrays, lower bound one.
         INTEGER, ALLOCATABLE:: AB(:,:)	!To be created to fit.
         INTEGER R,RA,RB,C,CA,CB,I	!Assistants.
          RA = UBOUND(A,DIM = 1)	!Ascertain the upper bounds of the incoming arrays.
          CA = UBOUND(A,DIM = 2)	!Their lower bounds will be deemed one,
          RB = UBOUND(B,DIM = 1)	!And the upper bound as reported will correspond.
          CB = UBOUND(B,DIM = 2)	!UBOUND(A) would give an array of two values, RA and CA, more for higher dimensionality.
          WRITE (6,1) "A",RA,CA,"B",RB,CB,"A.k.B",RA*RB,CA*CB	!Announce.
    1     FORMAT (3(A," is ",I0,"x",I0,1X))	!Three sets of sizes.
          IF (ALLOCATED(AB)) DEALLOCATE(AB)	!Discard any lingering storage.
          ALLOCATE (AB(RA*RB,CA*CB))		!Obtain the exact desired size.
          R = 0		!Syncopation: start the row offset.
          DO I = 1,RA	!Step down the rows of A.
            C = 0		!For each row, start the column offset.
            DO J = 1,CA		!Step along the columns of A.
              AB(R + 1:R + RB,C + 1:C + CB) = A(I,J)*B	!Place a block of B values.
              C = C + CB		!Advance a block of columns.
            END DO		!On to the next column of A.
            R = R + RB		!Advance a block of rows.
          END DO	!On to the next row of A.
        END SUBROUTINE KPRODUCT	!No tests for bad parameters, or lack of storage...

        SUBROUTINE SHOW(F,A)	!Write array A in row,column order.
         INTEGER F	!Output file unit number.
         INTEGER A(:,:)	!The 2-D array, lower bound one.
         INTEGER R	!The row stepper.
          DO R = 1,UBOUND(A,DIM = 1)	!Each row gets its own line.
            WRITE (F,1) A(R,:)		!Write all the columns of that row.
    1       FORMAT (666I3)		!This suffices for the example.
          END DO			!On to the next row.
        END SUBROUTINE SHOW	!WRITE (F,*) A or similar would show A as if transposed.
      END MODULE ARRAYMUSH	!That was simple enough.

      PROGRAM POKE
      USE ARRAYMUSH
      INTEGER A(2,2),B(2,2)		!First test: square arrays.
      INTEGER, ALLOCATABLE:: AB(:,:)	!To be created for each result.
      INTEGER C(3,3),D(3,4)		!Second test: some rectilinearity.
      DATA A/1,3, 2,4/,B/0,6, 5,7/	!Furrytran uses "column-major" order for successive storage elements.
      DATA C/0,1,0, 1,1,1, 0,1,0/	!So, the first three values go down the rows of the first column.
      DATA D/1,1,1, 1,0,1, 1,0,1, 1,1,1/!And then follow the values for the next column, etc.

      WRITE (6,*) "First test..."
      CALL KPRODUCT(A,B,AB)
      CALL SHOW (6,AB)

      WRITE (6,*)
      WRITE (6,*) "Second test..."
      CALL KPRODUCT(C,D,AB)
      CALL SHOW (6,AB)

      END
