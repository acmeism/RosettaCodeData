program aks
  implicit none

  ! Coefficients of polynomial expansion
  integer(kind=16), dimension(:), allocatable :: coeffs
  integer(kind=16) :: n
  ! Character variable for I/O
  character(len=40) :: tmp

  ! Point #2
  do n = 0, 7
    write(tmp, *) n
    call polynomial_expansion(n, coeffs)
    write(*, fmt='(A)', advance='no') '(x - 1)^'//trim(adjustl(tmp))//' ='
    call print_polynom(coeffs)
  end do

  ! Point #4
  do n = 2, 35
    if (is_prime(n)) write(*, '(I4)', advance='no') n
  end do
  write(*, *)

  ! Point #5
  do n = 2, 124
    if (is_prime(n)) write(*, '(I4)', advance='no') n
  end do
  write(*, *)

  if (allocated(coeffs)) deallocate(coeffs)
contains
  ! Calculate coefficients of (x - 1)^n using binomial theorem
  subroutine polynomial_expansion(n, coeffs)
    integer(kind=16), intent(in) :: n
    integer(kind=16), dimension(:), allocatable, intent(out) :: coeffs
    integer(kind=16) :: i, j

    if (allocated(coeffs)) deallocate(coeffs)

    allocate(coeffs(n + 1))

    do i = 1, n + 1
      coeffs(i) = binomial(n, i - 1)*(-1)**(n - i - 1)
    end do
  end subroutine

  ! Calculate binomial coefficient using recurrent relation, as calculation
  ! using factorial overflows too quickly.
  function binomial(n, k) result (res)
    integer(kind=16), intent(in) :: n, k
    integer(kind=16) :: res
    integer(kind=16) :: i

    if (k == 0) then
      res = 1
      return
    end if

    res = 1
    do i = 0, k - 1
      res = res*(n - i)/(i + 1)
    end do
  end function

  ! Outputs polynomial with given coefficients
  subroutine print_polynom(coeffs)
    integer(kind=16), dimension(:), allocatable, intent(in) :: coeffs
    integer(kind=4) :: i, p
    character(len=40) :: cbuf, pbuf
    logical(kind=1) :: non_zero

    if (.not. allocated(coeffs)) return

    non_zero = .false.

    do i = 1, size(coeffs)
      if (coeffs(i) .eq. 0) cycle

      p = i - 1
      write(cbuf, '(I40)') abs(coeffs(i))
      write(pbuf, '(I40)') p

      if (non_zero) then
        if (coeffs(i) .gt. 0) then
          write(*, fmt='(A)', advance='no') ' + '
        else
          write(*, fmt='(A)', advance='no') ' - '
        endif
      else
        if (coeffs(i) .gt. 0) then
          write(*, fmt='(A)', advance='no') '   '
        else
          write(*, fmt='(A)', advance='no') ' - '
        endif
      endif

      if (p .eq. 0) then
        write(*, fmt='(A)', advance='no') trim(adjustl(cbuf))
      elseif (p .eq. 1) then
        if (coeffs(i) .eq. 1) then
          write(*, fmt='(A)', advance='no') 'x'
        else
          write(*, fmt='(A)', advance='no') trim(adjustl(cbuf))//'x'
        end if
      else
        if (coeffs(i) .eq. 1) then
          write(*, fmt='(A)', advance='no') 'x^'//trim(adjustl(pbuf))
        else
          write(*, fmt='(A)', advance='no') &
            trim(adjustl(cbuf))//'x^'//trim(adjustl(pbuf))
        end if
      end if
      non_zero = .true.
    end do

    write(*, *)
  end subroutine

  ! Test if n is prime using AKS test. Point #3.
  function is_prime(n) result (res)
    integer(kind=16), intent (in) :: n
    logical(kind=1) :: res
    integer(kind=16), dimension(:), allocatable :: coeffs
    integer(kind=16) :: i

    call polynomial_expansion(n, coeffs)
    coeffs(1) = coeffs(1) + 1
    coeffs(n + 1) = coeffs(n + 1) - 1

    res = .true.

    do i = 1, n + 1
      res = res .and. (mod(coeffs(i), n) == 0)
    end do

    if (allocated(coeffs)) deallocate(coeffs)
  end function
end program aks
