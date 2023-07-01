program CustomComparator
  use comparators
  use sorts_with_custom_comparator
  implicit none

  character(len=100), dimension(8) :: str
  integer :: i

  str = (/ "this", "is", "an", "array", "of", "strings", "to", "sort" /)
  call a_sort(str, my_compare)

  do i = 1, size(str)
     print *, trim(str(i))
  end do
end program CustomComparator
