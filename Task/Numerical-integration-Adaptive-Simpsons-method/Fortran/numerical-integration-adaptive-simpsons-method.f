program adaptive_simpson_task
  implicit none

  integer, parameter :: dbl = kind (1.0d0)

  interface
     function function_dbl_to_dbl (x) result (y)
       import dbl
       real(dbl), intent(in) :: x
       real(dbl) :: y
     end function function_dbl_to_dbl
  end interface

  write (*, 1000) quad_asr (sine, 0.0_dbl, 1.0_dbl, 1E-9_dbl, 1000)
1000 format ("estimated definite integral of sin(x) ", &
       &  "for x from 0 to 1: ", F15.13)

contains

  function sine (x) result (y)
    real(dbl), intent(in) :: x
    real(dbl) :: y

    y = sin (x)
  end function sine

  function quad_asr (f, a, b, tol, depth) result (quadval)
    procedure(function_dbl_to_dbl) :: f
    real(dbl), intent(in) :: a, b, tol
    integer, intent(in) :: depth
    real(dbl) :: quadval

    real(dbl) :: fa, fb, m, fm, whole

    fa = f(a)
    fb = f(b)
    call quad_asr_simpsons_ (f, a, fa, b, fb, m, fm, whole)
    quadval = quad_asr_ (f, a, fa, b, fb, tol, whole, m, fm, depth)
  end function quad_asr

  recursive function quad_asr_ (f, a, fa, b, fb, tol, whole, &
       &                        m, fm, depth) result (quadval)
    procedure(function_dbl_to_dbl) :: f
    real(dbl), intent(in) :: a, fa, b, fb, tol, whole, m, fm
    integer, intent(in) :: depth
    real(dbl) :: quadval

    real(dbl) :: lm, flm, left
    real(dbl) :: rm, frm, right
    real(dbl) :: delta, tol_

    call quad_asr_simpsons_ (f, a, fa, m, fm, lm, flm, left)
    call quad_asr_simpsons_ (f, m, fm, b, fb, rm, frm, right)
    delta = left + right - whole
    tol_ = tol / 2
    if (depth <= 0 .or. tol_ == tol .or. abs (delta) <= 15 * tol) then
       quadval = left + right + (delta / 15)
    else
       quadval = quad_asr_ (f, a, fa, m, fm, tol_, left, &
            &               lm, flm, depth - 1)
       quadval = quadval + quad_asr_ (f, m, fm, b, fb, tol_, &
            &                         right, rm, frm, depth - 1)
    end if
  end function quad_asr_

  subroutine quad_asr_simpsons_ (f, a, fa, b, fb, m, fm, quadval)
    procedure(function_dbl_to_dbl) :: f
    real(dbl), intent(in) :: a, fa, b, fb
    real(dbl), intent(out) :: m, fm, quadval

    m = (a + b) / 2
    fm = f(m)
    quadval = ((b - a) / 6) * (fa + (4 * fm) + fb)
  end subroutine quad_asr_simpsons_

end program adaptive_simpson_task
!
! Below is a more modern version of the above, original code
!
module adaptive_simpson_mod
  implicit none
  integer, parameter :: dbl = kind(1.0d0)

  abstract interface
    function scalar_func(x) result(y)
      import dbl
      real(dbl), intent(in) :: x
      real(dbl) :: y
    end function
  end interface

contains

  function sine(x) result(y)
    real(dbl), intent(in) :: x
    real(dbl) :: y
    y = sin(x)
  end function sine

  function quad_asr(f, a, b, tol, depth) result(quadval)
    procedure(scalar_func) :: f
    real(dbl), intent(in) :: a, b, tol
    integer, intent(in) :: depth
    real(dbl) :: quadval

    real(dbl) :: fa, fb, m, fm, whole

    fa = f(a)
    fb = f(b)
    call simpsons(f, a, fa, b, fb, m, fm, whole)
    quadval = asr(f, a, fa, b, fb, tol, whole, m, fm, depth)
  end function quad_asr

  recursive function asr(f, a, fa, b, fb, tol, whole, m, fm, depth) result(quadval)
    procedure(scalar_func) :: f
    real(dbl), intent(in) :: a, fa, b, fb, tol, whole, m, fm
    integer, intent(in) :: depth
    real(dbl) :: quadval

    real(dbl) :: lm, flm, left, rm, frm, right, delta, tol_

    call simpsons(f, a, fa, m, fm, lm, flm, left)
    call simpsons(f, m, fm, b, fb, rm, frm, right)

    delta = left + right - whole
    tol_ = tol/2

    if (depth <= 0 .or. tol_ == tol .or. abs(delta) <= 15*tol) then
      quadval = left + right + delta/15
    else
      quadval = asr(f, a, fa, m, fm, tol_, left, lm, flm, depth-1)
      quadval = quadval + asr(f, m, fm, b, fb, tol_, right, rm, frm, depth-1)
    end if
  end function asr

  subroutine simpsons(f, a, fa, b, fb, m, fm, quadval)
    procedure(scalar_func) :: f
    real(dbl), intent(in) :: a, fa, b, fb
    real(dbl), intent(out) :: m, fm, quadval

    m = (a + b)/2
    fm = f(m)
    quadval = (b - a)/6 * (fa + 4*fm + fb)
  end subroutine simpsons

end module adaptive_simpson_mod

program adaptive_simpson_task
  use adaptive_simpson_mod
  implicit none

  write(*,'(A,F15.13)') "estimated definite integral of sin(x) for x from 0 to 1: ", &
       quad_asr(sine, 0.0_dbl, 1.0_dbl, 1e-9_dbl, 1000)
end program adaptive_simpson_task

!
