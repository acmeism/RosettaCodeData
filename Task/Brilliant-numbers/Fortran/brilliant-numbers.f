Brilliant numbers
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! Can be compiled on VSI Fortran x86-64 but it does not run on OpenVMS
! without modifying process quotas to allow abundant memory allocation
!
! U.B., March 2026
!
program Brilliant
implicit none

integer, allocatable :: primes(:)
integer :: primeCount
integer, parameter :: maxBrill=1010000000           ! Looking for the first B.N >= 1 000 000 000
integer, parameter ::  maxBrillToPrint=100
integer(kind=1), dimension(maxBrill) :: brill       ! indicates for each number up to the Maximum if it is brilliant

! Looking for the first "brilliant number" .gt. 1 000 000 000, i.e. the product of 2 primes
! not much larger than 1 000 000, it is sufficient to generate primes up to 200000
integer, parameter :: primeLimit=  200000

integer :: brilliantCount,  magnitude
integer(kind=8) :: brilliantNum
integer :: ii, jj, maxprimj

primeCount = initPrimes (primelimit)
brill = 0

! Find and display the first 100 brilliant numbers.
! The first entry is known:
brilliantCount = 0

! First construct all brilliant numbers from the preset primes.
outmost: do ii=1, primeCount
  jj = ii
  maxprimj = magMax (primes(ii))
  do while (jj .le. primecount .and. primes(jj) .le. maxprimj)
    ! Beware of overflow. Use 8 byte integer arithmetic to calculate brilliant numbers
    !
    brilliantNum =int(primes(ii),8)*int(primes(jj),8)
    brilliantCount = brilliantCount + 1
    if (brilliantNum .gt. 0 .and. BrilliantNum .le. maxBrill) then
      brill (brilliantNum) = 1
    endif
    jj = jj + 1
  end do
end do outmost

! Now print the first 100 numbers, in 10 lines
brilliantCount = 0
ii = 1
do while (brilliantCount .lt. maxBrillToPrint)
  if (brill(ii) .ne. 0) then
    brilliantCount = brilliantCount + 1
    write (*, '(i4, x)', advance='no')   ii
    if (mod (brilliantCount , 10) .eq. 0) write (*,*)     ! after 10 numbers, newline
  end if
  ii = ii + 1
end do

write (*,*)
jj=0

! For the orders of magnitude 1 through 9, find and show the first brilliant
! number greater than or equal to the order of magnitude, and, its position
! in the series (or the count of brilliant numbers up to that point).

 ii = 1
 maxprimj = 1                                            ! Set the limit to exceed
 brilliantCount = 0
 do ii=1, maxBrill                                       ! go through the Brill array
   if (brill(ii).ne. 0) then                             ! is this a brilliant number?
     brilliantCount = brilliantCount + 1                 ! yes, count it
     if (ii .ge. maxprimj) then                          ! Does it exceed the given limit? If so, print it
       write (*, '("First Brilliant Number .ge.", i10, " is ", i10, " at position ", i0 )')  maxprimj, ii,  brilliantCount
       maxprimj = 10*maxprimj                            ! next limit is 10 times larger
     endif
   endif
 end do

contains

! =============================================================
! return the largest number in the same order of magnitude as n
! =============================================================
function magMax (n) result (m)
integer, intent(in) :: n
integer :: m

! prepare for max 100 000 000
if (n .ge. 100000000) then
  m = 999999999
else if (n .ge. 10000000) then
  m = 99999999
else if (n .ge. 1000000) then
  m = 9999999
else if (n .ge. 100000) then
  m = 999999
else if (n .ge. 10000) then
  m = 99999
else if (n .ge. 1000) then
  m = 9999
else if (n .ge. 100) then
  m = 999
else if (n .ge. 10) then
  m = 99
else
  m = 9
endif

end function magMax

! ==============================
! The well-nown sieve for primes
! ==============================
function initPrimes (limit)  result (count)

integer, intent(in)  :: limit
! The array for the primes is located in main program
logical(kind=1), allocatable :: isPrime(:)

integer count
integer :: i, j,k

allocate(isPrime(limit))
if (.not. allocated (isPrime)) then
  print *, 'Cannot allocate enough memory for primes up to ', limit
  stop
end if

isPrime = .true.
primeCount = 0
do i = 2, limit
  if (isPrime(i)) then              ! Have a new prime
    primeCount = primeCount + 1
    do j = i+i, limit, i            ! Multiples of this prime aren't prime.
      isPrime(j) = .false.
    end do
  end if
end do
count = primecount
allocate (primes(primeCount))
if (.not. allocated (isPrime)) then
  print *, 'Cannot allocate enough memory for ', primeCount, ' primes.'
  stop
end if

j = 1
do i = 2, limit
  if (isPrime(i)) then
    primes(j) = i
    j = j + 1
    k=i
  end if
end do
deallocate (isPrime)
end function initPrimes


end program Brilliant
