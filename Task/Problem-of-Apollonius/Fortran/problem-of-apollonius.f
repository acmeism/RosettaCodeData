program Apollonius
  implicit none

  integer, parameter :: dp = selected_real_kind(15)

  type circle
    real(dp) :: x
    real(dp) :: y
    real(dp) :: radius
  end type

  type(circle) :: c1 , c2, c3, r

  c1 = circle(0.0, 0.0, 1.0)
  c2 = circle(4.0, 0.0, 1.0)
  c3 = circle(2.0, 4.0, 2.0)

  write(*, "(a,3f12.8))") "External tangent:", SolveApollonius(c1, c2, c3, 1, 1, 1)
  write(*, "(a,3f12.8))") "Internal tangent:", SolveApollonius(c1, c2, c3, -1, -1, -1)

contains

function SolveApollonius(c1, c2, c3, s1, s2, s3) result(res)
  type(circle) :: res
  type(circle), intent(in) :: c1, c2, c3
  integer, intent(in) :: s1, s2, s3

  real(dp) :: x1, x2, x3, y1, y2, y3, r1, r2, r3
  real(dp) :: v11, v12, v13, v14
  real(dp) :: v21, v22, v23, v24
  real(dp) :: w12, w13, w14
  real(dp) :: w22, w23, w24
  real(dp) :: p, q, m, n, a, b, c, det

  x1 = c1%x; x2 = c2%x; x3 = c3%x
  y1 = c1%y; y2 = c2%y; y3 = c3%y
  r1 = c1%radius; r2 = c2%radius; r3 = c3%radius

  v11 = 2*x2 - 2*x1
  v12 = 2*y2 - 2*y1
  v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2
  v14 = 2*s2*r2 - 2*s1*r1

  v21 = 2*x3 - 2*x2
  v22 = 2*y3 - 2*y2
  v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3
  v24 = 2*s3*r3 - 2*s2*r2

  w12 = v12/v11
  w13 = v13/v11
  w14 = v14/v11

  w22 = v22/v21-w12
  w23 = v23/v21-w13
  w24 = v24/v21-w14

  p = -w23/w22
  q = w24/w22
  m = -w12*P - w13
  n = w14 - w12*q

  a = n*n + q*q - 1
  b = 2*m*n - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1
  c = x1*x1 + m*m - 2*m*x1 + p*p + y1*y1 - 2*p*y1 - r1*r1

  det = b*b - 4*a*c
  res%radius = (-b-sqrt(det)) / (2*a)
  res%x = m + n*res%radius
  res%y = p + q*res%radius

end function
end program
