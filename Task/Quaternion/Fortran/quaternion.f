module Q_mod
  implicit none

  type quaternion
    real :: a, b, c, d
  end type

  public :: norm, neg, conj
  public :: operator (+)
  public :: operator (*)

  private ::  q_plus_q, q_plus_r, r_plus_q, &
              q_mult_q, q_mult_r, r_mult_q, &
              norm_q, neg_q, conj_q

  interface norm
    module procedure norm_q
  end interface

  interface neg
    module procedure neg_q
  end interface

  interface conj
    module procedure conj_q
  end interface

  interface operator (+)
    module procedure q_plus_q, q_plus_r, r_plus_q
  end interface

  interface operator (*)
    module procedure q_mult_q, q_mult_r, r_mult_q
  end interface

contains

function norm_q(x) result(res)
  real :: res
  type (quaternion), intent (in) :: x

  res = sqrt(x%a*x%a + x%b*x%b + x%c*x%c + x%d*x%d)

end function norm_q

function neg_q(x) result(res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x

  res%a = -x%a
  res%b = -x%b
  res%c = -x%c
  res%d = -x%d

end function neg_q

function conj_q(x) result(res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x

  res%a = x%a
  res%b = -x%b
  res%c = -x%c
  res%d = -x%d

end function conj_q

function q_plus_q(x, y) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x, y

  res%a = x%a + y%a
  res%b = x%b + y%b
  res%c = x%c + y%c
  res%d = x%d + y%d

end function q_plus_q

function q_plus_r(x, r) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x
  real, intent(in) :: r

   res = x
   res%a = x%a + r

end function q_plus_r

function r_plus_q(r, x) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x
  real, intent(in) :: r

   res = x
   res%a = x%a + r

end function r_plus_q

function q_mult_q(x, y) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x, y

   res%a = x%a*y%a - x%b*y%b - x%c*y%c - x%d*y%d
   res%b = x%a*y%b + x%b*y%a + x%c*y%d - x%d*y%c
   res%c = x%a*y%c - x%b*y%d + x%c*y%a + x%d*y%b
   res%d = x%a*y%d + x%b*y%c - x%c*y%b + x%d*y%a

end function q_mult_q

function q_mult_r(x, r) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x
  real, intent(in) ::  r

   res%a = x%a*r
   res%b = x%b*r
   res%c = x%c*r
   res%d = x%d*r

end function q_mult_r

function r_mult_q(r, x) result (res)
  type (quaternion) :: res
  type (quaternion), intent (in) :: x
  real, intent(in) ::  r

   res%a = x%a*r
   res%b = x%b*r
   res%c = x%c*r
   res%d = x%d*r

end function r_mult_q
end module Q_mod

program Quaternions
  use Q_mod
  implicit none

  real :: r = 7.0
  type(quaternion) :: q, q1, q2

  q  = quaternion(1, 2, 3, 4)
  q1 = quaternion(2, 3, 4, 5)
  q2 = quaternion(3, 4, 5, 6)

  write(*, "(a, 4f8.3)") "             q = ", q
  write(*, "(a, 4f8.3)") "            q1 = ", q1
  write(*, "(a, 4f8.3)") "            q2 = ", q2
  write(*, "(a, f8.3)")  "             r = ", r
  write(*, "(a, f8.3)")  "     Norm of q = ", norm(q)
  write(*, "(a, 4f8.3)") " Negative of q = ", neg(q)
  write(*, "(a, 4f8.3)") "Conjugate of q = ", conj(q)
  write(*, "(a, 4f8.3)") "         q + r = ", q + r
  write(*, "(a, 4f8.3)") "         r + q = ", r + q
  write(*, "(a, 4f8.3)") "       q1 + q2 = ", q1 + q2
  write(*, "(a, 4f8.3)") "         q * r = ", q * r
  write(*, "(a, 4f8.3)") "         r * q = ", r * q
  write(*, "(a, 4f8.3)") "       q1 * q2 = ", q1 * q2
  write(*, "(a, 4f8.3)") "       q2 * q1 = ", q2 * q1

end program
