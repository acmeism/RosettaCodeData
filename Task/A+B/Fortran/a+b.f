program a_plus_b
  implicit none
  integer :: a,b
  read (*, *) a, b
  write (*, '(i0)') a + b
end program a_plus_b
