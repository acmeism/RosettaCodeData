! Numerical integration/Tanh-Sinh Quadrature
!
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-
! IMPORTANT: 1. On the VMS system, use $FORTRAN /CCDEFAULT=LIST
!            2. GNU Fortran requires optimization level of at least -O2
!               otherwise it does not compile (-O0),
!               or the calculated result is wrong (-O1).
! U.B., July 2025

program progTanhSinhQuad
  implicit none
  !
  ! as in the task description, integrate sin(x) from 0 to 1, and exp(x) from -3 to 3.
  ! and show the results. Use myOwnSin and myOwnExp as wrapper functions because we cannot
  ! pass intrinsic functions as actual arguments.
  print '(F11.8)', tanh_sinh (myOwnSin, 0.0_8, 1.0_8, 5, 1e-8_8)
  print '(F11.8)', tanh_sinh (myOwnExp, -3.0_8, 3.0_8, 5, 1e-8_8)

contains


! This is a straight copy of the pseudo code shown in the task description,
! translated to Fortran.
!
function tanh_sinh (fun, lower, upper, steps, acc) result (integral)
  real(kind=8), intent(in) :: lower, upper, acc
  integer, intent(in)      :: steps
  real(kind=8) :: integral

  real(kind=8) :: h=0.1
  real(kind=8) :: h0, h1, rr, ro, ss, t, sh, ch, th, dx, xi, wt, PI
  integer      :: i, k, n

  interface
    pure function fun(x) result (res)
      real (kind=8), intent(in)  :: x
      real (kind=8)              :: res
    end function fun
  end interface

  PI=4.D0*DATAN(1.D0)

  h0 = (upper - lower) / 2.0
  h1 = (lower + upper) / 2.0
  rr = 0.0

  do k = 1, steps
        ro = rr
        ! n = (1 << k) - 1;
        n = ibset (0, k) - 1;
        ss = 0.0
        do i = -n,  n
          t = i * h
          sh = sinh(t)
          ch = cosh(t)
          th = tanh(sh * PI / 2.0)
          dx = (ch * PI / 2.0) / cosh(sh * PI / 2.0) **  2.0
          xi = h1 +  h0 * th
          wt = h * dx
          ss = ss + (fun (xi) * wt)
        end do
        rr = h0 * ss
        if (abs (rr-ro) .lt. acc) then
          integral = rr
          EXIT
        end if
  end do

  end function tanh_sinh
!
! cannot pass intrinsic functions as actual argument, using 2 wrapper functions instead.
!
pure function myOwnSin (x) result (r)
  real (kind=8), intent(in)  :: x
  real (kind=8)              :: r
  r =  dsin(x)
end function myOwnSin

pure function myOwnExp (x) result (r)
  real (kind=8), intent(in)  :: x
  real (kind=8)              :: r
  r = dexp (x)
end function myOwnExp

end program progTanhSinhQuad

