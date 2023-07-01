module continued_fractions
  implicit none

  integer, parameter :: long = selected_real_kind(7,99)

  type continued_fraction
    integer                            :: a0, b1
    procedure(series), pointer, nopass :: a, b
  end type

  interface
    pure function series (n)
      integer, intent(in) :: n
      integer             :: series
    end function
  end interface

contains

  pure function define_cf (a0,a,b1,b) result(x)
    integer, intent(in)           :: a0
    procedure(series)             :: a
    integer, intent(in), optional :: b1
    procedure(series),   optional :: b
    type(continued_fraction)      :: x
    x%a0 = a0
    x%a => a
    if ( present(b1) ) then
       x%b1 = b1
    else
       x%b1 = 1
    end if
    if ( present(b) ) then
       x%b => b
    else
       x%b => const_1
    end if
  end function define_cf

  pure integer function const_1(n)
    integer,intent(in) :: n
    const_1 = 1
  end function

  pure real(kind=long) function output(x,iterations)
    type(continued_fraction), intent(in) :: x
    integer,                  intent(in) :: iterations
    integer                              :: i
    output = x%a(iterations)
    do i = iterations-1,1,-1
      output = x%a(i) + (x%b(i+1) / output)
    end do
    output = x%a0 + (x%b1 / output)
  end function output

end module continued_fractions


program examples
  use continued_fractions

  type(continued_fraction) :: sqr2,napier,pi

  sqr2   = define_cf(1,a_sqr2)
  napier = define_cf(2,a_napier,1,b_napier)
  pi     = define_cf(3,a=a_pi,b=b_pi)

  write (*,*) output(sqr2,10000)
  write (*,*) output(napier,10000)
  write (*,*) output(pi,10000)

contains

  pure integer function a_sqr2(n)
    integer,intent(in) :: n
    a_sqr2 = 2
  end function

  pure integer function a_napier(n)
    integer,intent(in) :: n
    a_napier = n
  end function

  pure integer function b_napier(n)
    integer,intent(in) :: n
    b_napier = n-1
  end function

  pure integer function a_pi(n)
    integer,intent(in) :: n
    a_pi = 6
  end function

  pure integer function b_pi(n)
    integer,intent(in) :: n
    b_pi = (2*n-1)*(2*n-1)
  end function

end program examples
