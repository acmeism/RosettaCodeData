      SUBROUTINE SORT3(X,Y,Z) !Perpetrate a bubblesort in-line.
       CHARACTER*(*) X,Y,Z  !Just three to rearrange.
       CHARACTER*(MAX(LEN(X),LEN(Y),LEN(Z))) T  !Really, they should all be the same length.
        IF (X.GT.Y) CALL SWAPC(X,Y) !The first pass: for i:=2:3 do if a(i - 1) > a(i) swap
        IF (Y.GT.Z) CALL SWAPC(Y,Z) !The second test of the first pass.
        IF (X.GT.Y) CALL SWAPC(X,Y) !The second pass: for i:=2:2...
       CONTAINS   !Alas, Fortran does not offer a SWAP statement.
        SUBROUTINE SWAPC(A,B) !So, one must be devised for each case.
        CHARACTER*(*) A,B !To have their content swapped.
         T = A      !Ccpy the first to a safe space.
         A = B      !Copy the second on to the first.
         B = T      !Copy what had been first to the second.
        END SUBROUTINE SWAPC  !One of these will be needed for each type of datum.
       END SUBROUTINE SORT3 !No attempt is made to stop early, as for already-ordered data.

       PROGRAM POKE
       CHARACTER*28 XYZ(3,2)  !Encompass the two examples.
       DATA XYZ/    !Storage order is "column-major".
     1 'lions, tigers, and','bears, oh my!','(from the "Wizard of OZ")',  !So (1,1), (2,1), (3,1)
     2 '77444','  -12','    0'/ !So this looks like a transposed array. But     (1,2), (2,2), (3,2)
       INTEGER I    !A stepper for the loop.
       DO I = 1,2   !Two examples.
         WRITE (6,66) "Supplied: ", XYZ(1:3,I)  !As given.
   66    FORMAT (A12,3(" >",A,"<"))   !Show as >text< for clarity.

         CALL SORT3(XYZ(1,I),XYZ(2,I),XYZ(3,I)) !Three separate variables, that happen to be in an array.

         WRITE (6,66) "Sorted, ? ", XYZ(1:3,I)  !The result.
       END DO     !On to the next example.
       END  !Nothing much.
