! giuga.f90
!
! Finds Giuga numbers in ascending order.
!
! Definition:
!   A Giuga number is a COMPOSITE integer n such that, for every
!   distinct prime factor f of n, f divides (n/f - 1) exactly.
!
! Example (n = 30):
!   Prime factors: 2, 3, 5
!   30/2 - 1 = 14  ->  2 | 14  (yes)
!   30/3 - 1 =  9  ->  3 |  9  (yes)
!   30/5 - 1 =  5  ->  5 |  5  (yes)
!   => 30 is a Giuga number.
!
! Known values:
!   30, 858, 1722, 66198, 2214408306, ...
!   The 5th value exceeds 2^31, so int64 arithmetic is used throughout.
!
! Usage:
!   ./giuga
!   Output is printed as each number is found.

program giuga
    use iso_fortran_env, only: int64, output_unit
    implicit none

    ! Search ceiling -- covers the 5th known Giuga number (2,214,408,306)
    ! and a little beyond.  Raise it to hunt for the 6th.
    integer(int64), parameter :: SEARCH_LIMIT = 3000000000_int64

    integer(int64) :: n       ! Candidate being tested
    integer        :: count   ! How many Giuga numbers found so far

    count = 0

    write(*, '(A)') 'Searching for Giuga numbers...'
    write(*, '(A)') ''

    do n = 2, SEARCH_LIMIT

        if (is_giuga(n)) then
            count = count + 1
            write(*, '(A, I0, A, I0)') 'Giuga number ', count, ': ', n
            ! Flush immediately so results appear as they are found,
            ! which is useful during the long wait for the 5th.
            flush(output_unit)
        end if

    end do

    write(*, '(A)') ''
    write(*, '(A, I0, A, I0, A)') &
        'Search complete.  Found ', count, ' Giuga numbers up to ', SEARCH_LIMIT, '.'

contains

    ! ------------------------------------------------------------------
    ! is_giuga(n)
    !
    ! Returns .true. if n is a Giuga number, .false. otherwise.
    !
    ! Steps:
    !   1. Factorise n into distinct prime factors using trial division.
    !   2. Reject n if it is 1 or prime (Giuga numbers must be composite).
    !   3. For each prime factor f, test whether f | (n/f - 1).
    ! ------------------------------------------------------------------
    logical function is_giuga(n)
        integer(int64), intent(in) :: n

        ! Storage for distinct prime factors.  64 slots is far more than
        ! any number in our range can have (2*3*5*...*67 already > 3e26).
        integer(int64) :: factors(64)
        integer        :: nf       ! Number of distinct prime factors found
        integer        :: i        ! Loop index over factors
        integer(int64) :: f        ! Current trial divisor
        integer(int64) :: temp     ! Working copy of n, divided down as factors found

        ! ---- Step 1: factorise n by trial division ----

        nf   = 0
        temp = n

        ! Try f = 2 first, then all odd numbers up to sqrt(temp).
        ! We test f*f <= temp rather than f <= sqrt(temp) to stay in
        ! integer arithmetic and avoid floating-point rounding issues.
        f = 2
        do while (f * f <= temp)
            if (mod(temp, f) == 0_int64) then
                ! f is a prime factor -- record it once (distinct factors only)
                nf = nf + 1
                factors(nf) = f
                ! Divide out all copies of f so the next iteration
                ! will find the next distinct prime factor.
                do while (mod(temp, f) == 0_int64)
                    temp = temp / f
                end do
            end if
            ! Advance: after 2, step through odd numbers only
            if (f == 2_int64) then
                f = 3
            else
                f = f + 2
            end if
        end do

        ! If temp > 1 after the loop, what remains is a prime factor
        ! larger than sqrt(n) -- there can be at most one such factor.
        if (temp > 1_int64) then
            nf = nf + 1
            factors(nf) = temp
        end if

        ! ---- Step 2: composite check ----

        ! n = 1 has no prime factors at all -- not a Giuga number.
        if (nf == 0) then
            is_giuga = .false.
            return
        end if

        ! If the only prime factor equals n itself, n is prime.
        ! Primes are excluded from the Giuga definition.
        if (nf == 1 .and. factors(1) == n) then
            is_giuga = .false.
            return
        end if

        ! ---- Step 3: Giuga condition ----
        ! For every distinct prime factor f of n:
        !   f must divide (n/f - 1), i.e. mod(n/f - 1, f) == 0.

        is_giuga = .true.
        do i = 1, nf
            f = factors(i)
            if (mod(n/f - 1_int64, f) /= 0_int64) then
                ! This factor fails the condition -- n cannot be Giuga.
                is_giuga = .false.
                return
            end if
        end do

        ! All factors passed -- n is a Giuga number.

    end function is_giuga

end program giuga
