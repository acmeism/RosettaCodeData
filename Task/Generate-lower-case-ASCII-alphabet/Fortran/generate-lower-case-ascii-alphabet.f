  character(26) :: alpha
  integer :: i

  do i = 1, 26
    alpha(i:i) = achar(iachar('a') + i - 1)
  end do
