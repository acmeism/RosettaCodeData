program Equilibrium
  implicit none

  integer :: array(7) = (/ -7, 1, 5, 2, -4, 3, 0 /)

  call equil_index(array)

contains

subroutine equil_index(a)
  integer, intent(in) :: a(:)
  integer :: i

  do i = 1, size(a)
    if(sum(a(1:i-1)) == sum(a(i+1:size(a)))) write(*,*) i
  end do

end subroutine
end program
