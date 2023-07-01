program intersect_two_lines
  implicit none

  type point
    real::x,y
  end type point

  integer, parameter :: n = 4
  type(point)        :: p(n)

  p(1)%x = 4; p(1)%y = 0; p(2)%x = 6;  p(2)%y = 10 ! fist line
  p(3)%x = 0; p(3)%y = 3; p(4)%x = 10; p(4)%y = 7  ! second line

  call intersect(p, n)

  contains

  subroutine intersect(p,m)
  integer, intent(in)       :: m
  type(point), intent(in)   :: p(m)
  integer   :: i
  real      :: a(2), b(2) ! y = a*x + b, for each line
  real      :: x, y       ! intersect point
  real      :: dx,dy      ! working variables

  do i = 1, 2
    dx = p(2*i-1)%x - p(2*i)%x
    dy = p(2*i-1)%y - p(2*i)%y
    if( dx == 0.) then    ! in case this line is of the form y = b
        a(i) = 0.
        b(i) = p(2*i-1)%y
    else
        a(i)= dy / dx
        b(i) = p(2*i-1)%y - a(i)*p(2*i-1)%x
    endif
  enddo

  if( a(1) - a(2) == 0. ) then
    write(*,*)"lines are not intersecting"
    return
  endif

  x = ( b(2) - b(1) ) / ( a(1) - a(2) )
  y = a(1) * x + b(1)
  write(*,*)x,y
  end subroutine intersect
end program intersect_two_lines
