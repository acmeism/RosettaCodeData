!
! Eban numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program Eban
implicit none

  ! show all eban numbers   ≤   1,000   (in a horizontal format),   and a count
  ! show all eban numbers between   1,000   and   4,000   (inclusive),   and a count
  ! show a count of all eban numbers up and including           10,000
  ! show a count of all eban numbers up and including         100,000
  ! show a count of all eban numbers up and including      1,000,000
  ! show a count of all eban numbers up and including    10,000,000

  integer, parameter :: iMax = 4000

  integer :: ii
  integer, dimension(4),parameter :: add = [2,2,4,2]    ! For Optimisation: how much to increment ii in main loop
  integer :: idxadd = 1                                 ! only last digits 2,4,6,0 is needed, rest can be skipped.

  ii = 2
  do while (ii.le. iMax)
    if (ii .eq. 2) then
      write (*, '("eban numbers up to including 1000 (inclusive):")')
    endif

    if (isEban (ii)) then
      write (*, '(i0,x)', advance='no')   ii
    endif

    if (ii .eq. 1000) then
      ! prepare to print next line for 1000...4000
      write (*, '(//,"eban numbers between 1000 and 4000 (inclusive):")')
    else if (ii .eq. 4000) then
      write (*,'(//)')
    endif

    ! We only need numbers ii with least digit 2,4,6,or 0, not onE, thrEE, fivE, sEvEn, Eight, ninE
    ! Increment ii accordingly, so we have to check only 40% of all numbers.
    ii = ii + add(idxadd)
    idxadd = idxadd+1
    if (idxadd .eq. 5) idxadd=1
  end do

  do ii=2,21            ! 10^21 is 1 sextillon, (which is NOT eban), but formula fails for larger numbers.
    call countEban (ii)
  end do

  contains

    function isEban (n) result (YN)
    integer, intent(in) :: n
    logical :: YN
    integer :: thousands, remainder

    ! Take care this is not intended for large n!
    if (n .gt. 9999) then
      print *, 'use function isEban only for argument n < 10000.'
      stop
    end if

    thousands = n/1000
    remainder = n - 1000*thousands
    YN = .false.
    if (thousands .ge. 30 .and. thousands .le. 66) thousands = mod(thousands,10)
    if (remainder .ge. 30 .and. remainder .le. 66) remainder = mod(remainder,10)
    if (thousands .eq. 0 .or. thousands .eq. 2 .or. thousands .eq. 4 .or. thousands .eq. 6) then
      if (remainder .eq. 0 .or. remainder .eq. 2 .or. remainder .eq. 4 .or. remainder .eq. 6) then
        YN = .true.
      endif
    endif

    end function isEban

    ! ==========================================
    ! returns the count of eban numbers 10^pow10
    ! ==========================================
    subroutine countEban (pow10)
    integer, intent(in) :: pow10

    integer(kind=8) :: number
    integer :: cnt
    integer :: n, p5, p4

    n = pow10-pow10/3
    p5 = n/2
    p4 = (n+1)/2

    ! No formal proof of the used formula, but at least a Plausibility check:
    ! 1 digit 2,4,6,0         counts 4
    ! 2 digits 20,30,40,50,60 counts 5
    ! 3 digits: no hundEds at all. total=4*5=20 - 1 for the 0
    ! 1000:    pow10=3, n=2, p5=1, p4=1
    ! 10000:   pow10=4, n=3, p5=1, p4=2
    ! 100000:  pow10=5, n=4, p5=2, p4=2
    ! 1000000: pow10=6, n=4, p5=2, p4=2,
    ! etc... in other words:
    ! 3k   digits: 20^k -1  eban numbers             k=1:  10^(3*1)  =1000  -> 19 Eban
    ! 3k+1 digits: 20^k * 4 -1 = 5^k * 4^(k+1) -1          10^(3*1+1)=10000 -> 79 Eban
    ! 3k+2 digits: 20^k * 5 -1 = 5^k * 4^(k+2) -1          10^(3*1+2)=100000 -> 399 Eban
    ! This pattern repeats for k=2,3,4 etc. up to k=7, 10^21.
    ! Fails for pow10 .gt. 21 because that is a sExtillion
    cnt =  5**p5 * 4**p4 - 1

    if (pow10 .le. 18) then
      number = 10_8**pow10
      write (*,'("Number of eban numbers up to and including 10^", i2.2, " = " , i19, " is ", i0)')  pow10, number, cnt
    else
      ! calculation 10^19 etc. would overflow if Number is integer(8)
      write (*,'("Number of eban numbers up to and including 10^", i2.2, 22x, " is ", i0)')  pow10, cnt
    endif

    end subroutine countEban
end program Eban
