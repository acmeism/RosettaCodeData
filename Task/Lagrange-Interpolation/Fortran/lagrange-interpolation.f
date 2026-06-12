module lagrange_mod
  use fgsl
  implicit none

contains
  ! Function to compute Lagrange basis polynomial l_j(x)
  real(fgsl_double) function lagrange_basis(x, j, x_nodes, n)
    real(fgsl_double), intent(in) :: x
    integer, intent(in) :: j, n
    real(fgsl_double), intent(in) :: x_nodes(n)
    integer :: i
    real(fgsl_double) :: prod

    prod = 1.0_fgsl_double
    do i = 1, n
      if (i /= j) then
        if (x_nodes(j) - x_nodes(i) == 0.0_fgsl_double) then
          print *, 'Error: Duplicate nodes detected at index ', i, j
          stop
        end if
        prod = prod * (x - x_nodes(i)) / (x_nodes(j) - x_nodes(i))
      end if
    end do
    lagrange_basis = prod
  end function lagrange_basis

  ! Function to compute Lagrange interpolating polynomial P(x)
  real(fgsl_double) function lagrange_interpolate(x, x_nodes, y_nodes, n)
    real(fgsl_double), intent(in) :: x
    integer, intent(in) :: n
    real(fgsl_double), intent(in) :: x_nodes(n), y_nodes(n)
    integer :: j
    real(fgsl_double) :: sum

    sum = 0.0_fgsl_double
    do j = 1, n
      sum = sum + y_nodes(j) * lagrange_basis(x, j, x_nodes, n)
    end do
    lagrange_interpolate = sum
  end function lagrange_interpolate

  ! Subroutine to multiply two polynomials
  subroutine poly_multiply(poly1, n1, poly2, n2, result, nr)
    integer, intent(in) :: n1, n2
    real(fgsl_double), intent(in) :: poly1(n1), poly2(n2)
    integer, intent(out) :: nr
    real(fgsl_double), intent(out) :: result(n1+n2-1)
    integer :: i, j

    nr = n1 + n2 - 1
    result = 0.0_fgsl_double
    do i = 1, n1
      do j = 1, n2
        result(i+j-1) = result(i+j-1) + poly1(i) * poly2(j)
      end do
    end do
  end subroutine poly_multiply

  ! Subroutine to compute polynomial coefficients
  subroutine compute_lagrange_coefficients(x_nodes, y_nodes, n, coeffs)
    real(fgsl_double), intent(in) :: x_nodes(n), y_nodes(n)
    integer, intent(in) :: n
    real(fgsl_double), intent(out) :: coeffs(n)
    real(fgsl_double) :: poly(n*n), temp(n*n), denom, linear(2)
    integer :: poly_size, temp_size, i, j, k
    real(fgsl_double) :: basis_poly(n)

    coeffs = 0.0_fgsl_double
    do j = 1, n
      ! Initialize polynomial to 1
      poly = 0.0_fgsl_double
      poly(1) = 1.0_fgsl_double
      poly_size = 1
      ! Compute prod_{i!=j} (x - x_i)
      do i = 1, n
        if (i /= j) then
          linear = [ -x_nodes(i), 1.0_fgsl_double ]  ! x - x_i
          call poly_multiply(poly, poly_size, linear, 2, temp, temp_size)
          poly(1:temp_size) = temp(1:temp_size)
          poly_size = temp_size
        end if
      end do
      ! Compute denominator prod_{i!=j} (x_j - x_i)
      denom = 1.0_fgsl_double
      do i = 1, n
        if (i /= j) then
          denom = denom * (x_nodes(j) - x_nodes(i))
        end if
      end do
      ! Scale polynomial by y_j / denom
      basis_poly = 0.0_fgsl_double
      do k = 1, poly_size
        basis_poly(k) = poly(k) * y_nodes(j) / denom
      end do
      ! Add to total coefficients
      do k = 1, n
        coeffs(k) = coeffs(k) + basis_poly(k)
      end do
    end do
  end subroutine compute_lagrange_coefficients
end module lagrange_mod

program lagrange_interpolation
  use lagrange_mod
  use fgsl
  implicit none

  ! Data points: P(1)=1, P(2)=4, P(3)=1, P(4)=5
  integer, parameter :: n = 4
  real(fgsl_double) :: x_nodes(n) = [1.0_fgsl_double, 2.0_fgsl_double, 3.0_fgsl_double, 4.0_fgsl_double]
  real(fgsl_double) :: y_nodes(n) = [1.0_fgsl_double, 4.0_fgsl_double, 1.0_fgsl_double, 5.0_fgsl_double]
  real(fgsl_double) :: coeffs(n), x, y_manual, y_gsl
  integer :: i
  type(fgsl_spline) :: interp
  type(fgsl_interp_accel) :: accel
  integer(fgsl_int) :: status

  ! Print input data points
  print *, 'Input data points:'
  do i = 1, n
    print '(A,I1,A,F4.1,A,F4.1)', 'P(', i, ') = ', x_nodes(i), ' -> ', y_nodes(i)
  end do
  print *, ''

  ! Compute and print polynomial coefficients
  call compute_lagrange_coefficients(x_nodes, y_nodes, n, coeffs)
  print *, 'Lagrange Polynomial:'
  print '(F8.5,A,F9.5,A,F9.5,A,F9.5)', coeffs(4), 'x^3 + ', coeffs(3), 'x^2 + ', coeffs(2), 'x + ', coeffs(1)
  print *, ''

  ! Compute and print interpolation results using manual Lagrange method
  print *, 'Manual Lagrange Interpolation Results:'
  do i = 1, n
    x = x_nodes(i)
    y_manual = lagrange_interpolate(x, x_nodes, y_nodes, n)
    print '(A,F4.1,A,F8.4)', 'P(', x, ') = ', y_manual
  end do
  print *, ''

  ! Initialize GSL interpolation using fgsl
  print *, 'fgsl version:', fgsl_version
  interp = fgsl_spline_alloc(fgsl_interp_polynomial, int(n, fgsl_size_t))
  accel = fgsl_interp_accel_alloc()
  status = fgsl_spline_init(interp, x_nodes, y_nodes)
  if (status /= fgsl_success) then
    print *, 'Error: fgsl_spline_init failed with status ', status
    call fgsl_spline_free(interp)
    call fgsl_interp_accel_free(accel)
    stop
  end if

  ! Compute and print GSL interpolation results
  print *, 'GSL Interpolation Results:'
  do i = 1, n
    x = x_nodes(i)
    y_gsl = fgsl_spline_eval(interp, x, accel)
    print '(A,F4.1,A,F8.4)', 'P(', x, ') = ', y_gsl
  end do
  print *, ''

  ! Compare results
  print *, 'Comparison (Manual vs GSL):'
  do i = 1, n
    x = x_nodes(i)
    y_manual = lagrange_interpolate(x, x_nodes, y_nodes, n)
    y_gsl = fgsl_spline_eval(interp, x, accel)
    print '(A,F4.1,A,F8.4,A,F8.4,A,E10.4)', 'x = ', x, ': Manual = ', y_manual, &
          ', GSL = ', y_gsl, ', Difference = ', abs(y_manual - y_gsl)
  end do

  ! Clean up GSL resources
  call fgsl_spline_free(interp)
  call fgsl_interp_accel_free(accel)
end program lagrange_interpolation
