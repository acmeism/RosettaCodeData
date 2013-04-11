module geom

  type point
     real(8), private  :: x = 0
     real(8), private  :: y = 0
   contains
     procedure, public :: get_x
     procedure, public :: get_y
     procedure, public :: set_x
     procedure, public :: set_y
     procedure, public :: print => print_point
  end type point

  type, extends(point) :: circle
     real(8), private  :: r = 0
   contains
     procedure, public :: get_r
     procedure, public :: set_r
     procedure, public :: print => print_circle
  end type circle

contains

  real(8) function get_x(this)
    class(point), intent(in) :: this
    get_x = this%x
  end function get_x

  real(8) function get_y(this)
    class(point), intent(in) :: this
    get_y = this%y
  end function get_y

  subroutine set_x(this, val)
    class(point), intent(inout) :: this
    real(8), intent(in)         :: val
    this%x = val
  end subroutine set_x

  subroutine set_y(this, val)
    class(point), intent(inout) :: this
    real(8), intent(in)         :: val
    this%y = val
  end subroutine set_y

  subroutine print_point(this)
    class(point), intent(in) :: this
    write(*,'(2(a,f0.4),a)') 'Point(',this%x,', ',this%y,')'
  end subroutine print_point

  real(8) function get_r(this)
    class(circle), intent(in) :: this
    get_r = this%r
  end function get_r

  subroutine set_r(this, val)
    class(circle), intent(inout) :: this
    real(8), intent(in)          :: val
    this%r = val
  end subroutine set_r

  subroutine print_circle(this)
    class(circle), intent(in) :: this
    write(*,'(3(a,f0.4),a)') 'Circle(',this%x,', ',this%y,'; ',this%r,')'
  end subroutine print_circle

end module geom

program inh
  use geom

  type(point)  :: p
  type(circle) :: c

  p = point(2.0d0, 3.0d0)
  call p%print

  c = circle(3.0d0, 4.0d0, 5.0d0)
  call c%print

end program inh
