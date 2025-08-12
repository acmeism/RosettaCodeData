module cyclotomic_utils
  implicit none

  type :: IntArray
    integer, allocatable :: values(:)
    integer :: length
  end type IntArray

contains

  logical function is_prime(n)
    integer, intent(in) :: n
    integer :: i
    is_prime = .true.
    if (n < 2) then
      is_prime = .false.
      return
    end if
    do i = 2, int(sqrt(real(n)))
      if (mod(n, i) == 0) then
        is_prime = .false.
        return
      end if
    end do
  end function is_prime

  type(IntArray) function distinct_prime_factors(n) result(result)
    integer, intent(in) :: n
    integer :: i, temp
    integer :: temp_values(0:999)
    temp = n
    result%length = 0
    allocate(result%values(0:0))
    do i = 2, n
      if (mod(temp, i) == 0 .and. is_prime(i)) then
        result%length = result%length + 1
        temp_values(result%length-1) = i
        deallocate(result%values)
        allocate(result%values(0:result%length-1))
        result%values(0:result%length-1) = temp_values(0:result%length-1)
        do while (mod(temp, i) == 0)
          temp = temp / i
        end do
      end if
    end do
  end function distinct_prime_factors

  type(IntArray) function substitute_exponent(polynomial, exponent) result(result)
    type(IntArray), intent(in) :: polynomial
    integer, intent(in) :: exponent
    integer :: i
    result%length = exponent * (polynomial%length - 1) + 1
    allocate(result%values(0:result%length-1))
    result%values = 0
    do i = polynomial%length - 1, 0, -1
      result%values(i * exponent) = polynomial%values(i)
    end do
  end function substitute_exponent

  type(IntArray) function exact_division(dividend, divisor) result(result)
    type(IntArray), intent(in) :: dividend, divisor
    integer :: i, j
    integer, allocatable :: temp(:)
    logical :: remainder_nonzero
    result%length = dividend%length - divisor%length + 1
    if (result%length < 1) then
      result%length = 1
      allocate(result%values(0:0))
      result%values = 0
      return
    end if
    allocate(result%values(0:result%length-1))
    allocate(temp(0:dividend%length-1))
    temp = dividend%values
    do i = 0, dividend%length - divisor%length
      if (i >= size(result%values) .or. divisor%values(0) == 0) then
        result%values = 0
        return
      end if
      result%values(i) = temp(i)
      if (temp(i) /= 0) then
        do j = 1, divisor%length - 1
          if (i + j < dividend%length) then
            temp(i + j) = temp(i + j) - divisor%values(j) * temp(i)
          end if
        end do
      end if
    end do
    remainder_nonzero = .false.
    do i = dividend%length - divisor%length + 1, dividend%length - 1
      if (temp(i) /= 0) then
        remainder_nonzero = .true.
        exit
      end if
    end do
    if (remainder_nonzero) then
      result%values = 0
      result%length = 1
      allocate(result%values(0:0))
      result%values = 0
    end if
  end function exact_division

  type(IntArray) function cyclo_poly(cp_index) result(polynomial)
    integer, intent(in) :: cp_index
    integer :: i, product
    type(IntArray) :: primes, numerator
    if (cp_index == 1) then
      polynomial%length = 2
      allocate(polynomial%values(0:1))
      polynomial%values = [1, -1]
      return
    end if
    if (is_prime(cp_index)) then
      polynomial%length = cp_index
      allocate(polynomial%values(0:cp_index-1))
      polynomial%values = 1
      return
    end if
    polynomial%length = 2
    allocate(polynomial%values(0:1))
    polynomial%values = [1, -1]
    primes = distinct_prime_factors(cp_index)
    product = 1
    do i = 1, primes%length
      numerator = substitute_exponent(polynomial, primes%values(i-1))
      polynomial = exact_division(numerator, polynomial)
      product = product * primes%values(i-1)
    end do
    polynomial = substitute_exponent(polynomial, cp_index / product)
  end function cyclo_poly

  logical function has_height(polynomial, coefficient) result(found)
    type(IntArray), intent(in) :: polynomial
    integer, intent(in) :: coefficient
    integer :: i
    found = .false.
    do i = 0, polynomial%length - 1
      if (abs(polynomial%values(i)) == coefficient) then
        found = .true.
        return
      end if
    end do
  end function has_height

  subroutine print_polynomial(cp_index, poly)
    integer, intent(in) :: cp_index
    type(IntArray), intent(in) :: poly
    character(len=200) :: term, temp ! Increased length to 200
    logical :: first
    integer :: i
    write(*, '(A, I0, A)', advance='no') 'CP(', cp_index, ') = '
    first = .true.
    term = ''
    do i = poly%length - 1, 0, -1
      if (poly%values(i) /= 0) then
        temp = ''
        if (.not. first) then
          if (poly%values(i) > 0) then
            temp = ' + '
          else
            temp = ' '
          end if
        end if
        if (poly%values(i) /= 1 .or. i == 0) then
          if (poly%values(i) == -1 .and. i > 0) then
            temp = trim(temp) // '- '
          else
            write(temp, '(A, I0)') trim(temp), poly%values(i)
          end if
        end if
        if (i > 0) then
          temp = trim(temp) // 'x'
          if (i > 1) then
            write(temp, '(A, A, I0)') trim(temp), '^', i
          end if
        end if
        term = trim(term) // trim(temp)
        first = .false.
      end if
    end do
    write(*, '(A)') trim(term)
  end subroutine print_polynomial

end module cyclotomic_utils

program cyclotomic
  use cyclotomic_utils
  implicit none
  integer :: cp_index, coeff
  type(IntArray) :: poly

  ! Task 1: Print first 30 cyclotomic polynomials
  write(*, '(A)') 'Task 1: Cyclotomic polynomials for n <= 30:'
  write(*, '(A)') 'CP(1) = x - 1'
  do cp_index = 2, 30
    poly = cyclo_poly(cp_index)
    call print_polynomial(cp_index, poly)
  end do

  ! Task 2: Find smallest cyclotomic polynomial with n or -n
  write(*, '(A)') ''
  write(*, '(A)') 'Task 2: Smallest cyclotomic polynomial with n or -n as a coefficient:'
  write(*, '(A)') 'CP(1) has a coefficient with magnitude 1'
  cp_index = 2
  do coeff = 2, 10
    do while (is_prime(cp_index) .or. .not. has_height(cyclo_poly(cp_index), coeff))
      cp_index = cp_index + 1
    end do
    write(*, '(A, I5, A, I0)') 'CP(', cp_index, ') has a coefficient with magnitude ', coeff
  end do

end program cyclotomic
