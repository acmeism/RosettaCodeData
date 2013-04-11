program Example
  implicit none

  real :: r
  integer :: a, b

  do
     call random_number(r)
     a = int(r * 20)
     write(*,*) a
     if (a == 10) exit
     call random_number(r)
     b = int(r * 20)
     write(*,*) b
  end do

end program Example
