program perfect_numbers

  use module_rational
  implicit none
  integer, parameter :: n_min = 2
  integer, parameter :: n_max = 2 ** 19 - 1
  integer :: n
  integer :: factor
  type (rational) :: sum

  do n = n_min, n_max
    sum = 1 // n
    factor = 2
    do
      if (factor * factor >= n) then
        exit
      end if
      if (modulo (n, factor) == 0) then
        sum = rational_simplify (sum + (1 // factor) + (factor // n))
      end if
      factor = factor + 1
    end do
    if (sum % numerator == 1 .and. sum % denominator == 1) then
      write (*, '(i0)') n
    end if
  end do

end program perfect_numbers
