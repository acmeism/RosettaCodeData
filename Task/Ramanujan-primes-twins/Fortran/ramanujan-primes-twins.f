! Twin Ramanujan primes: consecutive Ramanujan primes R(n), R(n+1)
! with R(n+1) - R(n) = 2, analogous to twin primes.
!
! Algorithm for generating Ramanujan primes:
!   Walk two sorted lists simultaneously in value order:
!     (+1 events) at each prime p
!     (-1 events) at each 2*p  (p prime)
!   Maintain a running counter c = pi(x) - pi(x/2).
!   Each time c increases to a new level via a prime event,
!   rp(c) = that prime is the c-th Ramanujan prime R(c).
!
! Sieve upper bound: R(10^6) ~ 29 million (SLIM = 40 M gives ample margin).

program twin_ramujan_primes
  use iso_fortran_env, only: int64
  implicit none

  integer, parameter :: SLIM = 40000000  ! sieve ceiling
  integer, parameter :: N   = 1000000   ! Ramanujan primes to find

  logical(kind=1), allocatable :: sieve(:)
  integer,         allocatable :: primes(:), rp(:)
  integer        :: i, j, np, c, n_shown
  integer(int64) :: n_pairs

  ! ------------------------------------------------------------------ sieve
  write(*,'(A,I0,A)') 'Sieving primes to ', SLIM, ' ...'
  allocate(sieve(SLIM))
  sieve    = .true.
  sieve(1) = .false.
  do i = 2, int(sqrt(dble(SLIM)))
    if (sieve(i)) then
      do j = i*i, SLIM, i
        sieve(j) = .false.
      end do
    end if
  end do
  np = count(sieve)
  write(*,'(A,I0)') 'Primes in sieve: ', np

  allocate(primes(np))
  j = 0
  do i = 2, SLIM
    if (sieve(i)) then
      j = j + 1
      primes(j) = i
    end if
  end do
  deallocate(sieve)

  ! ------------------------------------------------------------------ R(n)
  write(*,'(A,I0,A)') 'Computing first ', N, ' Ramanujan primes ...'
  allocate(rp(N))
  rp = 0;  c = 0;  i = 1;  j = 1

  do while (i <= np)
    if (primes(i) < 2*primes(j)) then
      ! Prime event: pi(x)-pi(x/2) rises; record R(c) = this prime
      c = c + 1
      if (c <= N) rp(c) = primes(i)
      i = i + 1
    else
      ! Double-prime event: pi(x)-pi(x/2) falls
      c = c - 1
      j = j + 1
    end if
  end do

  if (rp(N) == 0) then
    write(*,'(A)') 'ERROR: sieve limit too small -- increase SLIM and recompile.'
    stop
  end if

  ! Spot-checks against OEIS A104272
  write(*,'(A)') 'Spot-checks (OEIS A104272):'
  write(*,'(2X,A,I0,A)') 'R(1)       = ', rp(1),  '   expected: 2'
  write(*,'(2X,A,I0,A)') 'R(2)       = ', rp(2),  '   expected: 11'
  write(*,'(2X,A,I0,A)') 'R(10)      = ', rp(10), '   expected: 101'
  write(*,'(2X,A,I0)')   'R(1000000) = ', rp(N)
  write(*,*)

  ! ------------------------------------------------------------------ twins
  ! A twin Ramanujan pair is (R(n), R(n+1)) with R(n+1) - R(n) = 2.
  ! Triple-twins (p, p+2, p+4 all Ramanujan primes) are impossible:
  ! three primes in AP with d=2 requires one divisible by 3, and the
  ! only such triple (3,5,7) contains no Ramanujan primes.
  ! Therefore n_individual_twins = 2 * n_pairs exactly.
  n_pairs = 0_int64
  n_shown = 0

  write(*,'(A)') 'First 15 twin Ramanujan prime pairs (R(n+1) - R(n) = 2):'
  write(*,'(A)') repeat('-', 54)

  do i = 1, N - 1
    if (rp(i+1) - rp(i) == 2) then
      n_pairs = n_pairs + 1_int64
      if (n_shown < 15) then
        write(*,'(2X,A,I6,A,I10,3X,A,I6,A,I10)') &
          'R(', i,   ') =', rp(i), &
          'R(', i+1, ') =', rp(i+1)
        n_shown = n_shown + 1
      end if
    end if
  end do

  write(*,'(A)') repeat('-', 54)
  write(*,*)
  write(*,'(A,I0,A)') 'Among the first ', N, ' Ramanujan primes:'
  write(*,'(2X,A,I0)') 'Twin pairs (R(n+1)-R(n) = 2):     ', n_pairs
  write(*,'(2X,A,I0)') 'Individual primes in a twin pair:  ', 2_int64*n_pairs

  deallocate(primes, rp)
end program twin_ramujan_primes
