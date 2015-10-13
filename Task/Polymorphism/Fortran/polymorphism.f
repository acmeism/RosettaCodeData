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
     procedure, pass :: copy_point
     !overloaded assignment operator
     generic, public :: assignment(=) => copy_point
  end type point

  type, extends(point) :: circle
     real(8), private  :: r = 0
   contains
     procedure, public :: get_r
     procedure, public :: set_r
     procedure, public :: print => print_circle
     procedure, pass :: copy_circle
     !overloaded assignment operator
     generic, public :: assignment(=) => copy_circle
  end type circle

  ! constructor interface
  interface circle
  module procedure circle_constructor
  end interface circle
  ! constructor interface
  interface point
  module procedure point_constructor
  end interface point

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

  subroutine copy_point(this, rhs)
      class(point), intent(inout) :: this
      type(point), intent(in) :: rhs
      this%x = rhs%x
      this%y = rhs%y
  end subroutine copy_point

  subroutine copy_circle(this, rhs)
      class(circle), intent(inout) :: this
      type(circle), intent(in) :: rhs
      this%x = rhs%x
      this%y = rhs%y
      this%r = rhs%r
  end subroutine copy_circle

! non-default constructor to init private components
  type(point) function point_constructor(x,y)
  real(8), intent(in) :: x,y
  point_constructor%x = x
  point_constructor%y = y
  end function point_constructor
! non-default constructor to init private components
  type(circle) function circle_constructor(x,y,r)
  real(8), intent(in) :: x,y,r
  circle_constructor%x = x
  circle_constructor%y = y
  circle_constructor%r = r
  end function circle_constructor

end module geom

program inh
  use geom

  type(point)  :: p, p_copy
  type(circle) :: c, c_copy

  p = point(2.0d0, 3.0d0)
  call p%print
  p_copy = p
  call p_copy%print

  c = circle(3.0d0, 4.0d0, 5.0d0)
  call c%print
  c_copy = c
  call c_copy%print

end program inh
