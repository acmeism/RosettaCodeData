program twosum
  implicit none

  integer, parameter, dimension(5) :: list = (/ 0, 2, 11, 19, 90/)
  integer, parameter :: target_val = 21
  integer :: nelem
  integer :: i, j
  logical :: success = .false.

  nelem = size(list)
  outer:do i = 1,nelem
     do j = i+1,nelem
        success = list(i) + list(j) == target_val
        if (success) exit outer
     end do
  end do outer

  if (success) then
     !Just some fancy formatting for nicer output
     print('("(",2(i3.1,1X),")",3(A1,i3.1))'), i,j, ":", list(i), "+", list(j), "=", target_val
  else
     print*, "Failed"
  end if

end program twosum
