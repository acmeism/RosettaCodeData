PROGRAM Example

  IMPLICIT NONE
  INTEGER :: rows, columns, errcheck
  INTEGER, ALLOCATABLE :: array(:,:)

  WRITE(*,*) "Enter number of rows"
  READ(*,*) rows
  WRITE(*,*) "Enter number of columns"
  READ(*,*) columns

  ALLOCATE (array(rows,columns), STAT=errcheck) ! STAT is optional and is used for error checking

  array(1,1) = 42

  WRITE(*,*) array(1,1)

  DEALLOCATE (array, STAT=errcheck)

END PROGRAM Example
