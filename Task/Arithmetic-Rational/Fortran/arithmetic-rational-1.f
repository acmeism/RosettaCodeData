module module_rational

  implicit none
  private
  public :: rational
  public :: rational_simplify
  public :: assignment (=)
  public :: operator (//)
  public :: operator (+)
  public :: operator (-)
  public :: operator (*)
  public :: operator (/)
  public :: operator (<)
  public :: operator (<=)
  public :: operator (>)
  public :: operator (>=)
  public :: operator (==)
  public :: operator (/=)
  public :: abs
  public :: int
  public :: modulo
  type rational
    integer :: numerator
    integer :: denominator
  end type rational
  interface assignment (=)
    module procedure assign_rational_int, assign_rational_real
  end interface
  interface operator (//)
    module procedure make_rational
  end interface
  interface operator (+)
    module procedure rational_add
  end interface
  interface operator (-)
    module procedure rational_minus, rational_subtract
  end interface
  interface operator (*)
    module procedure rational_multiply
  end interface
  interface operator (/)
    module procedure rational_divide
  end interface
  interface operator (<)
    module procedure rational_lt
  end interface
  interface operator (<=)
    module procedure rational_le
  end interface
  interface operator (>)
    module procedure rational_gt
  end interface
  interface operator (>=)
    module procedure rational_ge
  end interface
  interface operator (==)
    module procedure rational_eq
  end interface
  interface operator (/=)
    module procedure rational_ne
  end interface
  interface abs
    module procedure rational_abs
  end interface
  interface int
    module procedure rational_int
  end interface
  interface modulo
    module procedure rational_modulo
  end interface

contains

  recursive function gcd (i, j) result (res)
    integer, intent (in) :: i
    integer, intent (in) :: j
    integer :: res
    if (j == 0) then
      res = i
    else
      res = gcd (j, modulo (i, j))
    end if
  end function gcd

  function rational_simplify (r) result (res)
    type (rational), intent (in) :: r
    type (rational) :: res
    integer :: g
    g = gcd (r % numerator, r % denominator)
    res = r % numerator / g // r % denominator / g
  end function rational_simplify

  function make_rational (numerator, denominator) result (res)
    integer, intent (in) :: numerator
    integer, intent (in) :: denominator
    type (rational) :: res
    res = rational (numerator, denominator)
  end function make_rational

  subroutine assign_rational_int (res, i)
    type (rational), intent (out), volatile :: res
    integer, intent (in) :: i
    res = i // 1
  end subroutine assign_rational_int

  subroutine assign_rational_real (res, x)
    type (rational), intent(out), volatile :: res
    real, intent (in) :: x
    integer :: x_floor
    real :: x_frac
    x_floor = floor (x)
    x_frac = x - x_floor
    if (x_frac == 0) then
      res = x_floor // 1
    else
      res = (x_floor // 1) + (1 // floor (1 / x_frac))
    end if
  end subroutine assign_rational_real

  function rational_add (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: res
    res = r % numerator * s % denominator + r % denominator * s % numerator // &
        & r % denominator * s % denominator
  end function rational_add

  function rational_minus (r) result (res)
    type (rational), intent (in) :: r
    type (rational) :: res
    res = - r % numerator // r % denominator
  end function rational_minus

  function rational_subtract (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: res
    res = r % numerator * s % denominator - r % denominator * s % numerator // &
        & r % denominator * s % denominator
  end function rational_subtract

  function rational_multiply (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: res
    res = r % numerator * s % numerator // r % denominator * s % denominator
  end function rational_multiply

  function rational_divide (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: res
    res = r % numerator * s % denominator // r % denominator * s % numerator
  end function rational_divide

  function rational_lt (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: r_simple
    type (rational) :: s_simple
    logical :: res
    r_simple = rational_simplify (r)
    s_simple = rational_simplify (s)
    res = r_simple % numerator * s_simple % denominator < &
        & s_simple % numerator * r_simple % denominator
  end function rational_lt

  function rational_le (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: r_simple
    type (rational) :: s_simple
    logical :: res
    r_simple = rational_simplify (r)
    s_simple = rational_simplify (s)
    res = r_simple % numerator * s_simple % denominator <= &
        & s_simple % numerator * r_simple % denominator
  end function rational_le

  function rational_gt (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: r_simple
    type (rational) :: s_simple
    logical :: res
    r_simple = rational_simplify (r)
    s_simple = rational_simplify (s)
    res = r_simple % numerator * s_simple % denominator > &
        & s_simple % numerator * r_simple % denominator
  end function rational_gt

  function rational_ge (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    type (rational) :: r_simple
    type (rational) :: s_simple
    logical :: res
    r_simple = rational_simplify (r)
    s_simple = rational_simplify (s)
    res = r_simple % numerator * s_simple % denominator >= &
        & s_simple % numerator * r_simple % denominator
  end function rational_ge

  function rational_eq (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    logical :: res
    res = r % numerator * s % denominator == s % numerator * r % denominator
  end function rational_eq

  function rational_ne (r, s) result (res)
    type (rational), intent (in) :: r
    type (rational), intent (in) :: s
    logical :: res
    res = r % numerator * s % denominator /= s % numerator * r % denominator
  end function rational_ne

  function rational_abs (r) result (res)
    type (rational), intent (in) :: r
    type (rational) :: res
    res = sign (r % numerator, r % denominator) // r % denominator
  end function rational_abs

  function rational_int (r) result (res)
    type (rational), intent (in) :: r
    integer :: res
    res = r % numerator / r % denominator
  end function rational_int

  function rational_modulo (r) result (res)
    type (rational), intent (in) :: r
    integer :: res
    res = modulo (r % numerator, r % denominator)
  end function rational_modulo

end module module_rational
