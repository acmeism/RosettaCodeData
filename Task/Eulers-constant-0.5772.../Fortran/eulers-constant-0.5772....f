program euler_constant
  implicit none
  ! Define constants and variables
  real(16), parameter :: EULER_GAMMA = 0.57721566490153286_16
  real(16), parameter :: eps = epsilon(1.0e-6_16)
  real(16) :: a, b, h, n2, r, u, v
  integer :: k, k2, m, n
  real(16) :: s(0:1), B2(0:9)
  real(16), parameter :: eps_high = eps !1.0e-12_16

  ! Method 1: From the definition (Negoi, 1997)
  write(*, '(a)') "From the definition, err. 3e-10"
  n = 400
  h = 1.0_16
  do k = 2, n
     h = h + 1.0_16 / k
  end do
  a = log(real(n, 16) + 0.5_16 + 1.0_16 / (24.0_16 * n))
  write(*, '(a, f18.16)') "Hn    ", h
  write(*, '(a, f18.16, /, a, i0, /)') "gamma ", h - a, "k = ", n
  write(*, '(a, f18.16, /)') "error ", abs(h - a - EULER_GAMMA)

  ! Method 2: Sweeney, 1963
  write(*, '(a)') "Sweeney, 1963, err. idem"
  n = 21
  s = [0.0_16, real(n, 16)]
  r = real(n, 16)
  k = 1
  do
     k = k + 1
     r = r * real(n, 16) / k
     s(mod(k, 2)) = s(mod(k, 2)) + r / k
     if (r <= eps) exit
  end do
  write(*, '(a, f18.16, /, a, i0, /)') "gamma ", s(1) - s(0) - log(real(n, 16_16)), "k = ", k
  write(*, '(a, f18.16, /)') "error ", abs(s(1) - s(0) - log(real(n, 16)) - EULER_GAMMA)

  ! Method 3: Bailey, 1988
  write(*, '(a)') "Bailey, 1988"
  n = 5
  a = 1.0_16
  h = 1.0_16
  n2 = 2.0_16 ** n
  r = 1.0_16
  k = 1
  do
     k = k + 1
     r = r * n2 / k
     h = h + 1.0_16 / k
     b = a
     a = a + r * h
     if (abs(b - a) <= eps) exit
  end do
  a = a * n2 / exp(n2)
  write(*, '(a, f18.16, /, a, i0, /)') "gamma ", a - n * log(2.0_16), "k = ", k
  write(*, '(a, f18.16, /)') "error ", abs(a - n * log(2.0_16) - EULER_GAMMA)

  ! Method 4: Brent-McMillan, 1980 (original)
  write(*, '(a)') "Brent-McMillan, 1980 (original)"
  n = 13
  a = -log(real(n, 16))
  b = 1.0_16
  u = a
  v = b
  n2 = real(n, 16) * n
  k2 = 0
  k = 0
  do
     k2 = k2 + 2 * k + 1
     k = k + 1
     a = a * n2 / k
     b = b * n2 / k2
     a = (a + b) / k
     u = u + a
     v = v + b
     if (abs(a) <= eps) exit
  end do
  write(*, '(a, f18.16, /, a, i0, /)') "gamma ", u / v, "k = ", k
  write(*, '(a, f18.16, /)') "error ", abs(u / v - EULER_GAMMA)

  ! Method 5: Brent-McMillan, 1980 (enhanced for higher precision)
  write(*, '(a)') "Brent-McMillan, 1980 (enhanced)"
  n = 50
  a = -log(real(n, 16))
  b = 1.0_16
  u = a
  v = b
  n2 = real(n, 16) * n
  k2 = 0
  k = 0
  do
     k2 = k2 + 2 * k + 1
     k = k + 1
     a = a * n2 / k
     b = b * n2 / k2
     a = (a + b) / k
     u = u + a
     v = v + b
     if (abs(a) <= eps_high) exit
  end do
  write(*, '(a, f18.16, /, a, i0, /)') "gamma ", u / v, "k = ", k
  write(*, '(a, f18.16, /)') "error ", abs(u / v - EULER_GAMMA)

  ! Method 6: Euler's method, 1735
  write(*, '(a)') "How Euler did it in 1735"
  B2 = [1.0_16, 1.0_16/6, -1.0_16/30, 1.0_16/42, -1.0_16/30, &
        5.0_16/66, -691.0_16/2730, 7.0_16/6, -3617.0_16/510, 43867.0_16/798]
  m = 7
  if (m > 9) stop
  n = 10
  h = 1.0_16
  do k = 2, n
     h = h + 1.0_16 / k
  end do
  write(*, '(a, f18.16)') "Hn    ", h
  h = h - log(real(n, 16))
  write(*, '(a, f18.16)') "  -ln ", h
  a = -1.0_16 / (2.0_16 * n)
  n2 = real(n, 16) * n
  r = 1.0_16
  do k = 1, m
     r = r * n2
     a = a + B2(k) / (2.0_16 * k * r)
  end do
  write(*, '(a, f18.16, /, a, f18.16, /, a, i0)') &
       "err  ", a, "gamma ", h + a, "k = ", n + m
  write(*, '(a, f18.16, /)') "error ", abs(h + a - EULER_GAMMA)

  ! Reference value
  write(*, '(a, f18.16, /)') "C  =  ", EULER_GAMMA
end program euler_constant
