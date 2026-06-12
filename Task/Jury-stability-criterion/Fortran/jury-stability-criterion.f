program jury_stability
  use iso_fortran_env, only: real64
  implicit none

  real(kind=real64), parameter :: eps = 1.0e-14_real64

  write(*, '(a)') 'Jury Stability Criterion -- Test Suite'
  write(*, '(a)') '======================================'

  ! --- named test cases ---
  call run_test('Test 1: [1, 3.3, 4, 0.8]', &
       [1.0_real64, 3.3_real64, 4.0_real64, 0.8_real64])

  call run_test('Test 2: [1, 1.4, 0.71, 0.154, 0.012]', &
       [1.0_real64, 1.4_real64, 0.71_real64, 0.154_real64, 0.012_real64])

  call run_test('Test 3: [1, 0, -2, 0, 5]   z^4 - 2z^2 + 5', &
       [1.0_real64, 0.0_real64, -2.0_real64, 0.0_real64, 5.0_real64])

  call run_test('Test 4: [1, 1, 1]   z^2 + z + 1', &
       [1.0_real64, 1.0_real64, 1.0_real64])

  call run_test('Test 5: [-1, 2.5, -3]   -z^2 + 2.5z - 3  (sign-normalised)', &
       [-1.0_real64, 2.5_real64, -3.0_real64])

  call run_test('Test 6: [0, 0, 1, 2, 0]   leading zeros stripped -> z^2 + 2z', &
       [0.0_real64, 0.0_real64, 1.0_real64, 2.0_real64, 0.0_real64])

  call run_test('Test 7: [5]   constant polynomial', &
       [5.0_real64])

  call run_test('Test 8: [0]   zero polynomial', &
       [0.0_real64])

  call run_test('Test 9: [0, 0, 0]   zero polynomial', &
       [0.0_real64, 0.0_real64, 0.0_real64])

contains

  !------------------------------------------------------------
  ! Pre-process raw coefficients, then call jury_test.
  !   - Strip leading zeros
  !   - Normalise sign so a_0 > 0
  !   - Handle degenerate / constant / zero cases
  ! raw(1) is the leading coefficient (highest power).
  !------------------------------------------------------------
  subroutine run_test(label, raw)
    character(len=*),  intent(in) :: label
    real(kind=real64), intent(in) :: raw(:)

    real(kind=real64) :: a(size(raw))
    integer :: i, first, m

    write(*, *)
    write(*, '(a)') label
    write(*, '(a)') repeat('-', len_trim(label))

    a = raw
    m = size(a)

    ! Find first non-zero coefficient
    first = 0
    do i = 1, m
      if (abs(a(i)) > eps) then
        first = i
        exit
      end if
    end do

    if (first == 0) then
      write(*, '(a)') 'Zero polynomial -- undefined.'
      return
    end if

    if (first > 1) then
      write(*, '(a,i0,a)') 'Stripped ', first-1, ' leading zero(s).'
      m = m - (first - 1)
      a(1:m) = a(first : first + m - 1)
    end if

    ! Normalise sign: leading coefficient must be positive
    if (a(1) < -eps) then
      write(*, '(a)') 'Sign-normalised (multiplied by -1).'
      a(1:m) = -a(1:m)
    end if

    ! Degree = m-1; m==1 means constant
    if (m == 1) then
      write(*, '(2x,a,1pg14.6)') 'Constant polynomial, value = ', a(1)
      write(*, '(2x,a)') 'No roots -- trivially stable.'
      return
    end if

    ! a(1:m) passed as 0-based a(0:n) inside jury_test / print_polynomial
    call print_polynomial(a(1:m), m-1)
    call jury_test(a(1:m), m-1)
  end subroutine run_test

  !------------------------------------------------------------
  ! Print P(z) = a(0)z^n + a(1)z^(n-1) + ... + a(n)
  !------------------------------------------------------------
  subroutine print_polynomial(a, n)
    integer,           intent(in) :: n
    real(kind=real64), intent(in) :: a(0:n)
    integer :: i

    write(*, *)
    write(*, '(a)', advance='no') 'P(z) = '
    do i = 0, n
      if (i > 0) then
        if (a(i) >= 0.0_real64) then
          write(*, '(a)', advance='no') ' + '
        else
          write(*, '(a)', advance='no') ' - '
        end if
        write(*, '(g10.4)', advance='no') abs(a(i))
      else
        write(*, '(g10.4)', advance='no') a(i)
      end if
      select case (n - i)
      case (0)
      case (1)
        write(*, '(a)', advance='no') 'z'
      case default
        write(*, '(a,i0)', advance='no') 'z^', n-i
      end select
    end do
    write(*, *)
  end subroutine print_polynomial

  !------------------------------------------------------------
  ! Core Jury stability test.
  ! a(0:n): coefficients in descending power order, a(0) > 0.
  !
  ! Row reduction:  b_k = a_0*a_k - a_n*a_{n-k},  k=0..n-1
  ! Stability conditions checked at each reduction step:
  !   |first element| > |last element|
  !------------------------------------------------------------
  subroutine jury_test(a, n)
    integer,           intent(in) :: n
    real(kind=real64), intent(in) :: a(0:n)

    real(kind=real64) :: row(0:n), nxt(0:n)
    real(kind=real64) :: p1, pm1
    integer           :: i, sz, step
    logical           :: stable

    stable = .true.

    ! Evaluate P(1) and P(-1)
    p1  = sum(a(0:n))
    pm1 = 0.0_real64
    do i = 0, n
      pm1 = pm1 + a(i) * ((-1.0_real64)**(n-i))
    end do

    write(*, *)
    write(*, '(a)') 'Preliminary conditions:'
    write(*, '(2x,a,1pg15.6)') 'P( 1) = ', p1
    write(*, '(2x,a,1pg15.6)') 'P(-1) = ', pm1
    write(*, '(2x,a,1pg15.6,a,1pg15.6)') '|a_n| = ', abs(a(n)), '   a_0 = ', a(0)
    write(*, *)

    if (p1 <= 0.0_real64) then
      write(*, '(2x,a)') '[FAIL]  P(1) > 0  not satisfied'
      stable = .false.
    else
      write(*, '(2x,a)') '[PASS]  P(1) > 0'
    end if

    if (mod(n, 2) == 0) then
      if (pm1 <= 0.0_real64) then
        write(*, '(2x,a)') '[FAIL]  P(-1) > 0  not satisfied  [n even]'
        stable = .false.
      else
        write(*, '(2x,a)') '[PASS]  P(-1) > 0  [n even]'
      end if
    else
      if (pm1 >= 0.0_real64) then
        write(*, '(2x,a)') '[FAIL]  P(-1) < 0  not satisfied  [n odd]'
        stable = .false.
      else
        write(*, '(2x,a)') '[PASS]  P(-1) < 0  [n odd]'
      end if
    end if

    if (abs(a(n)) >= a(0)) then
      write(*, '(2x,a)') '[FAIL]  |a_n| < a_0  not satisfied'
      stable = .false.
    else
      write(*, '(2x,a)') '[PASS]  |a_n| < a_0'
    end if

    if (.not. stable) then
      write(*, *)
      write(*, '(a)') 'RESULT: ** UNSTABLE **  (necessary conditions not satisfied)'
      return
    end if

    if (n == 1) then
      write(*, *)
      write(*, '(a)') 'RESULT: ** STABLE **  (degree 1, no Jury array needed)'
      return
    end if

    write(*, *)
    write(*, '(a)') 'Jury array conditions  (|first| > |last| required at each step):'

    row(0:n) = a(0:n)
    sz   = n + 1
    step = 1

    do while (sz > 2)
      do i = 0, sz - 2
        nxt(i) = row(0)*row(i) - row(sz-1)*row(sz-1-i)
      end do

      if (abs(nxt(0)) > abs(nxt(sz-2))) then
        write(*, '(2x,a,i0,a,1pg15.6,a,1pg15.6,a)') &
          'Step ', step, ':  |first| =', abs(nxt(0)), &
          '   |last| =', abs(nxt(sz-2)), '   [PASS]'
      else
        write(*, '(2x,a,i0,a,1pg15.6,a,1pg15.6,a)') &
          'Step ', step, ':  |first| =', abs(nxt(0)), &
          '   |last| =', abs(nxt(sz-2)), '   [FAIL]'
        stable = .false.
      end if

      row(0:sz-2) = nxt(0:sz-2)
      sz   = sz - 1
      step = step + 1
      if (.not. stable) exit
    end do

    write(*, *)
    if (stable) then
      write(*, '(a)') 'RESULT: ** STABLE **  (all roots lie strictly inside the unit circle)'
    else
      write(*, '(a)') 'RESULT: ** UNSTABLE **  (Jury array condition failed)'
    end if
  end subroutine jury_test

end program jury_stability


