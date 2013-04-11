PURE SUBROUTINE Insertion_Sort(a)
  REAL, INTENT(in out), DIMENSION(:) :: a
  REAL :: temp
  INTEGER :: i, j

  DO i = 2, SIZE(a)
     j = i - 1
     temp = a(i)
     DO WHILE (j>=1 .AND. a(j)>temp)
        a(j+1) = a(j)
        j = j - 1
     END DO
     a(j+1) = temp
  END DO
END SUBROUTINE Insertion_Sort
