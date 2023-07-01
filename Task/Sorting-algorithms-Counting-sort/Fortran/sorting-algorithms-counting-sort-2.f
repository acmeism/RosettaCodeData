program test
  use CountingSort
  implicit none

  integer, parameter :: n = 100, max_age = 140

  real, dimension(n) :: t
  integer, dimension(n) :: ages

  call random_number(t)
  ages = floor(t * max_age)

  call counting_sort(ages, 0, max_age)

  write(*,'(I4)') ages

end program test
