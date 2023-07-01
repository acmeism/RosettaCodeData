      MODULE BAD IDEA	!Employ Cramer's rule for solving A.x = b...
       INTEGER MSG	!Might as well be here.
       CONTAINS		!The details.
        SUBROUTINE SHOWMATRIX(A)	!With nice vertical bars.
         DOUBLE PRECISION A(:,:)	!The matrix.
         INTEGER R,N			!Assistants.
          N = SIZE(A, DIM = 1)		!Instead of passing an explicit parameter.
          DO R = 1,N			!Work down the rows.
            WRITE (MSG,1) A(R,:)		!Fling forth a row at a go.
    1       FORMAT ("|",<N>F12.3,"|")		!Bounded by bars.
          END DO			!On to the next row.
        END SUBROUTINE SHOWMATRIX	!Furrytran's default order is the transpose.

        RECURSIVE DOUBLE PRECISION FUNCTION DET(A)	!Determine the determinant.
         DOUBLE PRECISION A(:,:)	!The square matrix, order N.
         DOUBLE PRECISION MINOR(SIZE(A,DIM=1) - 1,SIZE(A,DIM=1) - 1)	!Order N - 1.
         DOUBLE PRECISION D		!A waystation.
         INTEGER C,N			!Steppers.
          N = SIZE(A, DIM = 1)		!Suplied via secret parameters.
          IF (N .LE. 0) THEN		!This really ought not happen.
            STOP "DET: null array!"		!But I'm endlessly suspicious.
          ELSE IF (N .NE. SIZE(A, DIM = 2)) THEN	!And I'd rather have a decent message
            STOP "DET: not a square array!"	!In place of a crashed run.
          ELSE IF (N .EQ. 1) THEN	!Alright, now get on with it.
            DET = A(1,1)		!This is really easy.
          ELSE				!But otherwise,
            D = 0			!Here we go.
            DO C = 1,N			!Step along the columns of the first row.
              CALL FILLMINOR(C)			!Produce the auxiliary array for each column.
              IF (MOD(C,2) .EQ. 0) THEN		!Odd or even case?
                D = D - A(1,C)*DET(MINOR)	!Even: subtract.
               ELSE				!Otherwise,
                D = D + A(1,C)*DET(MINOR)	!Odd: add.
              END IF				!So much for that term.
            END DO			!On to the next.
            DET = D		!Declare the result.
          END IF	!So much for that.
         CONTAINS	!An assistant.
           SUBROUTINE FILLMINOR(CC)	!Corresponding to A(1,CC).
           INTEGER CC	!The column being omitted.
           INTEGER R	!A stepper.
           DO R = 2,N		!Ignoring the first row,
             MINOR(R - 1,1:CC - 1) = A(R,1:CC - 1)	!Copy columns 1 to CC - 1. There may be none.
             MINOR(R - 1,CC:) = A(R,CC + 1:)		!And from CC + 1 to N. There may be none.
           END DO		!On to the next row.
          END SUBROUTINE FILLMINOR	!Divide and conquer.
        END FUNCTION DET	!Rather than mess with permutations.

        SUBROUTINE CRAMER(A,X,B)	!Solve A.x = b, where A is a matrix...
Careful! The array must be A(N,N), and not say A(100,100) of which only up to N = 6 are in use.
         DOUBLE PRECISION A(:,:)	!A square matrix. I hope.
         DOUBLE PRECISION X(:),B(:)	!Column matrices look rather like 1-D arrays.
         DOUBLE PRECISION AUX(SIZE(A,DIM=1),SIZE(A,DIM=1))	!Can't say "LIKE A", as in pl/i, alas.
         DOUBLE PRECISION D	!To be calculated once.
         INTEGER N		!The order of the square matrix. I hope.
         INTEGER C		!A stepper.
          N = SIZE(A, DIM = 1)	!Alright, what's the order of battle?
          D = DET(A)		!Once only.
          IF (D.EQ.0) STOP "Cramer: zero determinant!"	!Surely, this won't happen...
          AUX = A		!Prepare the assistant.
          DO C = 1,N		!Step across the columns.
            IF (C.GT.1) AUX(1:N,C - 1) = A(1:N,C - 1)	!Repair previous damage.
            AUX(1:N,C) = B(1:N)		!Place the current damage.
            X(C) = DET(AUX)/D		!The result!
          END DO		!On to the next column.
        END SUBROUTINE CRAMER	!This looks really easy!
      END MODULE BAD IDEA	!But actually, it is a bad idea for N > 2.

      PROGRAM TEST	!Try it and see.
      USE BAD IDEA	!Just so.
      DOUBLE PRECISION, ALLOCATABLE ::A(:,:), B(:), X(:)	!Custom work areas.
      INTEGER N,R	!Assistants..
      INTEGER INF	!An I/O unit.

      MSG = 6		!Output.
      INF = 10		!For reading test data.
      OPEN (INF,FILE="Test.dat",STATUS="OLD",ACTION="READ")	!As in this file..

Chew into the next problem.
   10 IF (ALLOCATED(A)) DEALLOCATE(A)	!First,
      IF (ALLOCATED(B)) DEALLOCATE(B)	!Get rid of
      IF (ALLOCATED(X)) DEALLOCATE(X)	!The hired help.
      READ (INF,*,END = 100) N		!Since there is a new order.
      IF (N.LE.0) GO TO 100		!Perhaps a final order.
      WRITE (MSG,11) N			!Othewise, announce prior to acting.
   11 FORMAT ("Order ",I0," matrix A, as follows...")	!In case something goes wrong.
      ALLOCATE(A(N,N))			!For instance,
      ALLOCATE(B(N))			!Out of memory.
      ALLOCATE(X(N))			!But otherwise, a tailored fit.
      DO R = 1,N			!Now read in the values for the matrix.
        READ(INF,*,END=667,ERR=665) A(R,:),B(R)	!One row of A at a go, followed by B's value.
      END DO				!In free format.
      CALL SHOWMATRIX(A)		!Show what we have managed to obtain.
      WRITE (MSG,12) "In the scheme A.x = b, b = ",B	!In case something goes wrong.
   12 FORMAT (A,<N>F12.6)		!How many would be too many?
      CALL CRAMER(A,X,B)		!The deed!
      WRITE (MSG,12) "    Via Cramer's rule, x = ",X	!The result!
      GO TO 10				!And try for another test problem.

Complaints.
  665 WRITE (MSG,666) "Format error",R	!I know where I came from.
  666 FORMAT (A," while reading row ",I0,"!")	!So I can refer to R.
      GO TO 100		!So much for that.
  667 WRITE (MSG,666) "End-of-file", R		!Some hint as to where.

Closedown.
  100 WRITE (6,*) "That was interesting."	!Quite.
      END	!Open files are closed, allocated memory is released.
