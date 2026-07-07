! Product of min and max prime factors
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., July 2026

program prodMinMaxPrime
implicit none
!
! We need only the 25 primes below 100,sieve would be overkill
!
! The only reason it is done this way: VSI Fortran does not accept integer, dimension(*),parameter primes
integer, parameter :: nprimes = 25            ! There are exactly 25 primes below 100
integer,dimension(nprimes),parameter :: primes=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]

integer :: ii, mini, maxi, prod               ! loop index 1...100, min and max prime factore of ii, and the product of them

write (*, '(i5)', advance='no') 1             ! For some reason, the term for 1 is defined to be 1

do ii=2, 100                                  ! for 2...100, find smin and max prime factors and print their product
  call minmaxp (ii, mini, maxi)
  prod=mini * maxi
  write (*, '(i5)', advance='no')  prod
  if (mod (ii, 10) .eq. 0) then               ! 1 line contains not more than 10 results
    write (*,*)
  endif
enddo
contains

! ==============================================================
! Find minimum 'mi' and maximum 'ma' prime factors of number 'n'
! ==============================================================
subroutine minmaxp (n, mi,ma)
integer, intent(in) :: n
integer, intent(out) :: mi, ma

integer :: ii

mi=-1                                         ! Indicates 'not yet set'
do ii=1, nprimes
  if (mod (n, primes(ii)) .eq. 0) then        ! this prime divides n:
    if (mi .lt. 0) mi = primes(ii)            !   +set minimum prime factor if not yet done
    ma = primes(ii)                           !   +Eventually, this will be the maximum prime factor
  endif
end do
end subroutine minmaxp
end program prodMinMaxPrime
