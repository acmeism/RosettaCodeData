program Filter
  use funcs
  implicit none

  integer, parameter                 :: N = 100
  integer, dimension(N)              :: array
  integer, dimension(:), pointer     :: filtered

  integer :: i

  forall(i=1:N) array(i) = i

  filtered => filterwith(array, iseven)
  print *, filtered

contains

  function filterwith(ar, testfunc)
    integer, dimension(:), pointer        :: filterwith
    integer, dimension(:), intent(in)     :: ar
    interface
       elemental function testfunc(x)
         logical :: testfunc
         integer, intent(in) :: x
       end function testfunc
    end interface

    integer :: i, j, n

    n = count( testfunc(ar) )
    allocate( filterwith(n) )

    j = 1
    do i = lbound(ar, dim=1), ubound(ar, dim=1)
       if ( testfunc(ar(i)) ) then
          filterwith(j) = ar(i)
          j = j + 1
       end if
    end do

  end function filterwith

end program Filter
