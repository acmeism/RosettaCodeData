Numbers which are the cube roots of the product of their proper divisors
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program CRD
implicit none

integer, parameter ::limit = 110*1000*1000

integer(kind=1), dimension(0:limit) :: sol
integer, allocatable,dimension(:) :: primes
integer :: highPrimes
integer (kind=8) :: gblCount


integer :: i,cnt,lmt

call SievePrimes (limit/6)    ! // 2*3*c * (c> 3 prime)
gblCount = 0
call Get_a7()
call Get_a3_b()
call Get_a_b_c()

Write(*,'("First 50 numbers which are the cube roots of the products of their proper divisors:")')

cnt = 0
i = 1

do while (cnt .lt. 50)
  if (sol(i) .ne. 0) then
    write (*,'(i5,x)', advance='no')    i
    cnt = cnt + 1
    if (mod(cnt,10) .eq. 0) then
      write (*,*)
    endif
  endif
  i = i + 1
enddo
write (*,*) ! empty line
lmt = 500
i=i-1
do
  do while (cnt .lt. lmt)
    i=i+1
    if (sol(i) .ne. 0) cnt = cnt + 1
    if (i .gt. limit) EXIT
  enddo
  if (i .gt. limit) EXIT
  write (*, '(I7, "th", x , ":", 2x, I0)')    lmt, i

  lmt = lmt * 10
  if (lmt .gt. limit)   EXIT
enddo
write (*, '("Total found: " , i0, " up to ", i0 )')  gblCount, limit


contains

subroutine SievePrimes(lmt)
  implicit none
  integer :: lmt
  integer(kind=1), dimension(:), allocatable :: sieve
  integer :: p,i,delta


  allocate (sieve (lmt/2) )
  sieve=0
  ! estimate count of prime
!  i = floor (lmt/(log (real(lmt, 8))-1.1_8))
  i = int (real(lmt,8)/(log (real(lmt, 8))-1.1_8))
  allocate (primes(0:i-1))
  highPrimes = i-1          ! highes usable index
  p = 1
  do
    delta = 2*p+1
    !  ((2*p+1)^2 ) -1)/ 2 = ((4*p*p+4*p+1) -1)/2 = 2*p*(p+1)
    i = 2*p*(p+1)
    if (i.gt. size(sieve))  exit

    do while (i <= size(sieve))
      sieve(i) = 1
      i = i+delta
    end do
    p=p+1
    do while (sieve(p) .ne. 0)
      p=p+1
    end do
  end do

  primes(0) = 2
  i = 1
  do p = 1,  size (sieve)
    if  (sieve(p) .eq.  0)   then
      primes(i) = 2*p+1
      i = i+1
    endif
  end do
  highPrimes = i-1    ! instead of (in Fortran) non-existant re-allocate with reduced length
end subroutine SievePrimes


subroutine  Get_a7()
  implicit none
  integer (kind=8) :: q3,n
  integer :: i

  sol(1) = 1
  gblCount = gblcount + 1;
  do i = 0,   highPrimes
    q3 = primes(i)
    n = sqr(sqr(sqr((q3)))) / q3    ! q3 ^7
    if (n .gt. limit) EXIT
    sol(n) = 1
    gblCount = gblCount + 1
  end do
end subroutine  Get_a7

function sqr(n) result (retval)
implicit none
integer (kind=8), intent(in) :: n
integer (kind=8) :: retval

retval = n*n
end function sqr



subroutine  Get_a3_b ()
  implicit none
  integer(kind=8) :: i,j,q3,n

  do i = 0 , highPrimes
    q3 = primes(i)
    q3 = q3*q3*q3
    if (q3 .gt. limit)   exit

    do j = 0, highPrimes
      if (j .eq. i) cycle
      n = Primes(j)*q3
      if (n .gt. limit) EXIT
      sol(n) = 1
      gblCount = gblCount + 1
    end do
  end do
  end subroutine Get_a3_b


subroutine  Get_a_b_c()
implicit none

integer(kind=8) ::  i,j,k,q1,q2,n

  do i =0, highPrimes-2
    q1 = primes(i)
    do j = i+1, highPrimes-1
      q2= q1*Primes(j)
      if (q2 .gt. limit)   exit
      do k = j+1,  highPrimes
        n = q2*Primes(k);
        if ( n .gt. limit ) exit
        sol(n) = 1
        gblCount = gblCount + 1
      enddo
    end do
  end do
end subroutine Get_a_b_c


end program CRD
