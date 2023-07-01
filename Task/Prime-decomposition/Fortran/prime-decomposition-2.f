program Primes
  use PrimeDecompose
  implicit none

  integer, dimension(100) :: outprimes
  integer i

  outprimes = 0

  call find_factors(12345649494449_huge, outprimes)

  do i = 1, 100
     if ( outprimes(i) == 0 ) exit
     print *, outprimes(i)
  end do

end program Primes
