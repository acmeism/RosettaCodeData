program moser_circles_extended
  implicit none
  integer, parameter :: p = 20
  integer :: i
  integer :: seq(0:p-1), bt(0:p-1), tri(0:p-1), dp(0:p-1)
  integer :: cum(0:p-1), newt(0:p-1), gen(0:p-1)

  print *, 'The first 20 values of Moser''s circle problem calculated in different ways:'

  print *
  print *, 'Direct calculation of a 4th order equation:'
  do i = 1, p
    write(*, '(I0,A)', advance='no') moser(i), ' '
  end do
  print *

  print *
  print *, 'Using binomial sums:'
  do i = 1, p
    write(*, '(I0,A)', advance='no') binomial(i,4) + binomial(i,2) + 1, ' '
  end do
  print *

  print *
  print *, 'Using a binomial transform:'
  seq = 0
  seq(0:4) = 1
  call binomial_transform(seq, bt, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') bt(i), ' '
  end do
  print *

  print *
  print *, 'Partial sums of Pascal''s triangle:'
  call pascals_triangle(tri, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') tri(i), ' '
  end do
  print *

  print *
  print *, 'Using finite difference recurrence:'
  call moser_recurrence(bt, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') bt(i), ' '
  end do
  print *

  print *
  print *, 'Using the difference engine (additions only):'
  call moser_difference_engine(bt, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') bt(i), ' '
  end do
  print *

  print *
  print *, 'Using first-difference recurrence:'
  call moser_first_diff(cum, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') cum(i), ' '
  end do
  print *

  print *
  print *, 'Using central polygonal numbers relation:'
  call moser_polygonal(dp, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') dp(i), ' '
  end do
  print *

  print *
  print *, 'Using Newton divided differences (new):'
  call moser_newton(newt, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') newt(i), ' '
  end do
  print *

  print *
  print *, 'Using generating function coefficients (new):'
  call moser_generating(gen, p)
  do i = 0, p-1
    write(*, '(I0,A)', advance='no') gen(i), ' '
  end do
  print *

contains

  integer function moser(n)
    integer, intent(in) :: n
    moser = (n**4 - 6*n**3 + 23*n**2 - 18*n + 24) / 24
  end function moser

  integer function binomial(n, k)
    integer, intent(in) :: n, k
    integer :: i, res
    if (k < 0 .or. k > n) then
      binomial = 0
      return
    end if
    res = 1
    do i = 1, k
      res = res * (n - i + 1) / i
    end do
    binomial = res
  end function binomial

  subroutine binomial_transform(seq, res, np)
    integer, intent(in)  :: seq(0:)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n, k, s
    do n = 0, np-1
      s = 0
      do k = 0, n
        s = s + binomial(n, k) * seq(k)
      end do
      res(n) = s
    end do
  end subroutine binomial_transform

  subroutine moser_recurrence(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n
    res(0) = 1;  res(1) = 2;  res(2) = 4;  res(3) = 8;  res(4) = 16
    do n = 5, np-1
      res(n) = 5*res(n-1) - 10*res(n-2) + 10*res(n-3) - 5*res(n-4) + res(n-5)
    end do
  end subroutine moser_recurrence

  subroutine moser_difference_engine(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n, d0, d1, d2, d3
    d0 = 1;  d1 = 1;  d2 = 1;  d3 = 1
    res(0) = d0
    do n = 1, np-1
      d0 = d0 + d1
      d1 = d1 + d2
      d2 = d2 + d3
      d3 = d3 + 1
      res(n) = d0
    end do
  end subroutine moser_difference_engine

  subroutine pascals_triangle(tri, np)
    integer, intent(out) :: tri(0:)
    integer, intent(in)  :: np
    integer :: r, c
    do r = 0, np-1
      tri(r) = 0
      do c = 0, 4
        tri(r) = tri(r) + binomial(r, c)
      end do
    end do
  end subroutine pascals_triangle

  ! First-difference recurrence: moser(n+1) = moser(n) + C(n,3) + C(n,1)
  ! Derived from C(n+1,k) - C(n,k) = C(n,k-1), applied to each term of
  ! moser(n) = C(n,4) + C(n,2) + 1, so the step reduces to C(n,3) + C(n,1).
  subroutine moser_first_diff(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n
    res(0) = 1
    do n = 1, np-1
      res(n) = res(n-1) + binomial(n, 3) + binomial(n, 1)
    end do
  end subroutine moser_first_diff

  subroutine moser_polygonal(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n
    integer :: tetra, triang
    ! res(n) = moser(n+1) = C(n+1,4) + C(n+1,2) + 1  (0-based n)
    do n = 0, np-1
      if (n >= 3) then
        tetra = (n+1)*n*(n-1)*(n-2)/24  ! C(n+1,4)
      else
        tetra = 0
      end if
      if (n >= 1) then
        triang = (n+1)*n/2              ! C(n+1,2)
      else
        triang = 0
      end if
      res(n) = tetra + triang + 1
    end do
  end subroutine moser_polygonal

  ! NEW: Newton's divided differences interpolation.
  ! Since Moser(n) is a degree-4 polynomial, we can use the first 5 values
  ! to build the Newton form and evaluate it for all n.
  ! The Newton form is: P(n) = c0 + c1*(n-1) + c2*(n-1)*(n-2) + ...
  subroutine moser_newton(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: i, j, n
    integer :: x(0:4)
    real(8) :: dd(0:4, 0:4), coeff(0:4), val

    ! Use points (1,1), (2,2), (3,4), (4,8), (5,16) - the first 5 values
    do i = 0, 4
      x(i) = i + 1
      dd(i, 0) = real(2**i, kind=8)
    end do

    ! Build divided difference table using real(8) -- integer division would
    ! truncate the fractional coefficients (e.g. 1/2, 1/6, 1/24) to zero
    do j = 1, 4
      do i = 0, 4-j
        dd(i,j) = (dd(i+1,j-1) - dd(i,j-1)) / real(x(i+j) - x(i), kind=8)
      end do
    end do

    ! Newton coefficients: dd(0, 0:4) = [1, 1, 1/2, 1/6, 1/24]
    coeff(0:4) = dd(0, 0:4)

    ! Evaluate Newton polynomial via Horner's method for n = 1 to np
    do n = 1, np
      val = coeff(4)
      do i = 3, 0, -1
        val = val * real(n - x(i), kind=8) + coeff(i)
      end do
      res(n-1) = nint(val)
    end do
  end subroutine moser_newton

  ! NEW: Generating function approach.
  ! G(x) = (1 - 3x + 4x^2 - 2x^3 + x^4) / (1-x)^5
  ! Derived from: x^3/(1-x)^5 + x/(1-x)^3 + 1/(1-x), combined over (1-x)^5.
  ! Coefficients: res(n) = sum_{k=0..min(n,4)} num(k) * C(n-k+4, 4)
  subroutine moser_generating(res, np)
    integer, intent(out) :: res(0:)
    integer, intent(in)  :: np
    integer :: n, k
    integer :: num(0:4)

    ! Numerator: 1 - 3x + 4x^2 - 2x^3 + x^4
    num(0) = 1; num(1) = -3; num(2) = 4; num(3) = -2; num(4) = 1

    ! For 1/(1-x)^5, the coefficients are C(n+4,4) = (n+4)(n+3)(n+2)(n+1)/24
    ! The product of numerator with 1/(1-x)^5 gives our sequence
    ! We compute convolution: res[n] = sum_{k=0..min(n,4)} num[k] * C(n-k+4,4)

    do n = 0, np-1
      res(n) = 0
      do k = 0, min(n, 4)
        ! C((n-k)+4, 4) = (n-k+4)(n-k+3)(n-k+2)(n-k+1)/24
        res(n) = res(n) + num(k) * binomial(n - k + 4, 4)
      end do
    end do
  end subroutine moser_generating

end program moser_circles_extended
