program prg_test
  use rref
  implicit none

  real, dimension(3, 4) :: m = reshape( (/  1, 2, -1, -4,  &
                                            2, 3, -1, -11, &
                                           -2, 0, -3,  22 /), &
                                        (/ 3, 4 /), order = (/ 2, 1 /) )
  integer :: i

  print *, "Original matrix"
  do i = 1, size(m,1)
     print *, m(i, :)
  end do

  call to_rref(m)

  print *, "Reduced row echelon form"
  do i = 1, size(m,1)
     print *, m(i, :)
  end do

end program prg_test
