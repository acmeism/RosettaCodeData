module primes_mod
  implicit none

  logical, allocatable :: primes(:)

contains

subroutine Genprimes(parr)
  logical, intent(in out) :: parr(:)
  integer :: i
! Prime sieve
  parr = .true.
  parr (1) = .false.
  parr (4 : size(parr) : 2) = .false.
  do i = 3, int (sqrt (real (size(parr)))), 2
    if (parr(i)) parr(i * i : size(parr) : i) = .false.
  end do

end subroutine

function is_rtp(candidate)
  logical :: is_rtp
  integer, intent(in) :: candidate
  integer :: n

  is_rtp = .true.
  n = candidate / 10
  do while(n > 0)
    if(.not. primes(n)) then
      is_rtp = .false.
      return
    end if
    n = n / 10
  end do

end function

function is_ltp(candidate)
  logical :: is_ltp
  integer, intent(in) :: candidate
  integer :: i, n
  character(10) :: nstr

  write(nstr, "(i10)") candidate
  is_ltp = .true.
  do i = len_trim(nstr)-1, 1, -1
    n = mod(candidate, 10**i)
    if(.not. primes(n)) then
      is_ltp = .false.
      return
    end if
  end do
end function

end module primes_mod

program Truncatable_Primes
  use primes_mod
  implicit none

  integer, parameter :: limit = 999999
  integer :: i
  character(10) :: nstr

! Generate an array of prime flags up to limit of search
  allocate(primes(limit))
  call Genprimes(primes)

! Find left truncatable prime
  do i = limit, 1, -1
    write(nstr, "(i10)") i
    if(index(trim(nstr), "0") /= 0) cycle      ! check for 0 in number
    if(is_ltp(i)) then
      write(*, "(a, i0)") "Largest left truncatable prime below 1000000 is ", i
      exit
    end if
  end do

! Find right truncatable prime
  do i = limit, 1, -1
    write(nstr, "(i10)") i
    if(index(trim(nstr), "0") /= 0) cycle      ! check for 0 in number
    if(is_rtp(i)) then
      write(*, "(a, i0)") "Largest right truncatable prime below 1000000 is ", i
      exit
    end if
  end do
end program
