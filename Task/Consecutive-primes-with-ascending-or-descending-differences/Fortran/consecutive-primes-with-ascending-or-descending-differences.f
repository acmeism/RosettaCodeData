! Consecutive primes with ascending or descending differences
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
program consecutivePrimes
implicit none

integer, parameter :: N=1000000
integer (kind=1 ), dimension(N) :: p

integer :: incmaxl, incmaxstart, incd, incl, incstart, incprev, d
integer :: decmaxl, decmaxstart, decd, decl, decstart, decprev
integer :: ii, jj, kk
call setupPrimes (p, N)

incmaxl=0
incmaxstart=2
incd=0
incl=1
incstart=2
incprev=2

decmaxl=0
decmaxstart=2
decd=0
decl=1

ii = n
do while (p(ii) .ne. 1)
  ii = ii -1
enddo

decstart=ii
decprev=ii



do ii=3, n
  if (p(ii).eq.1) then
    ! ii is prime

    ! First care for the Increasing sequence
    d = ii - incprev                      ! Difference to previous prime in sequence
    if (d .gt. incd) then                 ! difference increasing?
      incd = d                            ! Store current difference
      incprev = ii                        ! store current prime as previous in sequence
      incl = incl + 1                     ! increment sequence length
    else                                  ! increase has stopped at prev
      if (incl .gt. incmaxl) then         ! is current length > previous max length?
        incmaxl = incl                    ! Store maximum sequence lentth
        incmaxstart = incstart            ! and begin of current sequence
      endif

      ! Maybe start increasing again here?
      incl = 2                            ! Current length is 2 then: prev and this prime.
      incd = d
      incstart = incprev                  ! sequence start was at previous  prime
      incprev = ii                        ! Current prime becomes previous
    endif
  endif

  ! Now find the decreasing sequence:  from n down to 3, this is increasing
  jj = n+3-ii   ! jj goes from n to 3 when ii goes from 3 to n
  if (p(jj) .eq. 1) then
    ! jj is prime
    d = - jj + decprev                    ! Difference to previous prime in sequence
    if (d .gt. decd) then                 ! Difference decreasing?
      ! still decreasing
      decd = d                            ! Store current difference
      decprev = jj                        ! store current prime as previous in sequence
      decl = decl + 1                     ! increment sequence length
    else
      ! decrease has ended at prev
      if (decl .ge. decmaxl) then         ! is current length >= previous max length?
      !                                   ! check >= bc we want lowest such sequence, not highest.
        decmaxl = decl                    ! Store maximum sequence lentth
        decmaxstart = decstart            ! and begin of current sequence
      endif

      ! Maybe start decreasing again?
      decl = 2
      decd = d
      decstart = decprev
      decprev=jj
    endif
  endif
enddo


write (*,'("The longest sequence of primes with ascending differences contains ",i0, " primes:")') incmaxl
ii = incmaxstart
jj=ii
kk=0
do while (kk .lt. incmaxl)
  if (p(jj).eq.1) then
    write (*, '(X, I0)', advance='no') jj
    kk=kk+1
  endif
  jj = jj + 1
enddo
write (*,'(/)')    ! 1 empty line

write (*,'("The longest sequence of primes with descending differences contains ",i0, " primes:")') decmaxl
ii = decmaxstart
jj=ii
kk=0

! To print from the smalles to the largest primt of this sequence, find the smallest first.
do while (kk .lt. decmaxl)
  if (p(jj).eq.1) then
    ! this is not to print, just to find the start point to print in increasing order
    kk=kk+1
  endif
  jj = jj - 1
enddo

! Now we can print in correct order.
jj=jj+1
kk=0
do while (kk .lt. decmaxl)
  if (p(jj).eq.1) then
    write (*, '(X, I0)', advance='no') jj
    kk=kk+1
  endif
  jj = jj + 1
enddo
write (*,*)
contains

! =======================================================================
! Setup array p with n entries, indicating p(k)=1 if k is a prime, else 0
! =======================================================================
subroutine setupPrimes (p,n)
integer , intent(in) :: n
integer(kind=1) , dimension(n), intent(out) :: p

integer  :: i, j

p = -1
p(1) = 0

do i=2,n
  if (p(i) .eq. -1) then
    ! i is a prime number
    p(i) = 1
    ! All multiples of i are not prime.
    do j=i+i,n,i
      p(j) = 0
    enddo
  endif
enddo
end subroutine setupPrimes

end program consecutivePrimes
