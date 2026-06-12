module erdos
  private
  integer, parameter, public :: MAX_N = 2500
  integer, parameter, public :: STRETCH_LIMIT = 2000000
  public is_erdos_prime, find_nth_erdos_prime, sieve_of_eratosthenes
  contains
  subroutine sieve_of_eratosthenes(limit, is_prime, primes)
    implicit none
    integer, intent(in) :: limit
    logical, intent(out) :: is_prime(limit)
    integer, allocatable, intent(out) :: primes(:)
    integer :: p, i, prime_count

    is_prime = .true.
    is_prime(1) = .false.

    do p = 2, int(sqrt(real(limit)))
      if (is_prime(p)) then
        do i = p * p, limit, p
          is_prime(i) = .false.
        end do
      end if
    end do

    prime_count = count(is_prime,dim=1)
    allocate(primes(prime_count))

    prime_count = 0
    do i = 2, limit
      if (is_prime(i)) then
        prime_count = prime_count + 1
        primes(prime_count) = i
      end if
    end do
  end subroutine sieve_of_eratosthenes

  function factorial(n) result(fact)
    implicit none
    integer, intent(in) :: n
    integer(kind=8) :: fact

    fact = GAMMA(REAL((N+1)))
  end function factorial

  function is_erdos_prime(p, is_prime) result(erdos)
    implicit none
    integer, intent(in) :: p
    logical, intent(in) :: is_prime(:)
    logical :: erdos
    integer :: k
    integer(kind=8) :: k_fact

    erdos = .true.
    k = 1
    do
      k_fact = factorial(k)
      if (k_fact >= p) exit
      if (is_prime(p - k_fact)) then
        erdos = .false.
        exit
      end if
      k = k + 1
    end do
  end function is_erdos_prime

  function find_nth_erdos_prime(n, is_prime, primes) result(nth_prime)
    implicit none
    integer, intent(in) :: n
    logical, intent(in) :: is_prime(:)
    integer, intent(in) :: primes(:)
    integer :: nth_prime, counter, i

    counter = 0
    do i = 1, size(primes)
      if (is_erdos_prime(primes(i), is_prime)) then
        counter = counter + 1
        if (counter == n) then
          nth_prime = primes(i)
          return
        end if
      end if
    end do

    nth_prime = -1  ! Not found
  end function find_nth_erdos_prime
end module erdos
!
program erdos_primes
  use erdos
  implicit none
  logical, allocatable :: is_prime(:)
  integer, allocatable :: primes(:)
  integer :: i, counter, erdos_7875th

  ! Generate primes up to STRETCH_LIMIT
  allocate(is_prime(STRETCH_LIMIT))
  call sieve_of_eratosthenes(STRETCH_LIMIT, is_prime, primes)

  ! Find Erdos primes less than 2500
  print *, "Erdos primes less than 2500:"
  counter = 0
  do i = 1, size(primes)
    if (primes(i) >= MAX_N) exit
    if (is_erdos_prime(primes(i), is_prime)) then
      write(*, '(I5)', advance='no') primes(i)
      counter = counter + 1
      if (mod(counter, 10) == 0) print *
    end if
  end do
  print *
  print *, "Number of Erdos primes less than 2500:", counter

  ! Stretch goal: Find the 7,875th Erdos prime
  erdos_7875th = find_nth_erdos_prime( 7875, is_prime, primes)
  print *, "The 7,875th Erdos prime is:", erdos_7875th
!
  erdos_7875th = find_nth_erdos_prime( 9999, is_prime, primes)
  print *, "The 9,999th Erdos prime is:", erdos_7875th
end program erdos_primes
