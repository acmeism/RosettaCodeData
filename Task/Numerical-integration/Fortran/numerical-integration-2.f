module Integration
  implicit none

contains

  ! function, lower limit, upper limit, steps, method
  function integrate(f, a, b, in, method)
    real :: integrate
    real, intent(in) :: a, b
    integer, optional, intent(in) :: in
    character(len=*), intent(in), optional :: method
    interface
       elemental function f(ra)
         real :: f
         real, intent(in) :: ra
       end function f
    end interface

    integer :: n, i, m
    real :: h
    real, dimension(:), allocatable :: xpoints
    real, dimension(:), target, allocatable :: fpoints
    real, dimension(:), pointer :: fleft, fmid, fright

    if ( present(in) ) then
       n = in
    else
       n = 20
    end if

    if ( present(method) ) then
       select case (method)
       case ('leftrect')
          m = 1
       case ('midrect')
          m = 2
       case ('rightrect')
          m = 3
       case ( 'trapezoid' )
          m = 4
       case default
          m = 0
       end select
    else
       m = 0
    end if

    h = (b - a) / n

    allocate(xpoints(0:2*n), fpoints(0:2*n))

    xpoints = (/ (a + h*i/2, i = 0,2*n) /)

    fpoints = f(xpoints)
    fleft  => fpoints(0 : 2*n-2 : 2)
    fmid   => fpoints(1 : 2*n-1 : 2)
    fright => fpoints(2 : 2*n   : 2)

    select case (m)
    case (0) ! simpson
       integrate = h / 6.0 * sum(fleft + fright + 4.0*fmid)
    case (1) ! leftrect
       integrate = h * sum(fleft)
    case (2) ! midrect
       integrate = h * sum(fmid)
    case (3) ! rightrect
       integrate = h * sum(fright)
    case (4) ! trapezoid
       integrate = h * sum(fleft + fright) / 2
    end select

    deallocate(xpoints, fpoints)
  end function integrate

end module Integration
