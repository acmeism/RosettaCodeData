program thue_morse
  implicit none
  logical :: f(32) = .false.
  integer :: n = 1

  do
    write(*,*) f(1:n)
    if (n > size(f)/2) exit
    f(n+1:2*n) = .not. f(1:n)
    n = n * 2
  end do

end program thue_morse
