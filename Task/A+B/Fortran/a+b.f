program a_plus_b

  implicit none
  integer :: a
  integer :: b

  read (*, *) a, b
  write (*, '(i0)') a + b

end program a_plus_b
