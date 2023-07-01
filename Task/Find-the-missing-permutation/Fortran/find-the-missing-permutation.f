program missing_permutation

  implicit none
  character (4), dimension (23), parameter :: list =                    &
    & (/'ABCD', 'CABD', 'ACDB', 'DACB', 'BCDA', 'ACBD', 'ADCB', 'CDAB', &
    &   'DABC', 'BCAD', 'CADB', 'CDBA', 'CBAD', 'ABDC', 'ADBC', 'BDCA', &
    &   'DCBA', 'BACD', 'BADC', 'BDAC', 'CBDA', 'DBCA', 'DCAB'/)
  integer :: i, j, k

  do i = 1, 4
    j = minloc ((/(count (list (:) (i : i) == list (1) (k : k)), k = 1, 4)/), 1)
    write (*, '(a)', advance = 'no') list (1) (j : j)
  end do
  write (*, *)

end program missing_permutation
