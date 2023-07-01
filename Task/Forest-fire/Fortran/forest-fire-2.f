program ForestFireTest
  use ForestFireModel
  implicit none

  type(forestfire) :: f
  integer :: i

  f = forestfire_new(74, 40)

  do i = 1, 1001
     write(*,'(A)', advance='no') achar(z'1b') // '[H' // achar(z'1b') // '[2J'
     call forestfire_print(f)
     call forestfire_evolve(f)
  end do

  call forestfire_destroy(f)

end program ForestFireTest
