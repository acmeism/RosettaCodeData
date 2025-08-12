! Disarium numbers
!
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
! U.B., July 2025

program progDisarium

implicit none

! Others have already shown: 20th Disarium number has 20 digits
! This will not fit in signed 8-byte-integer.  Current Fortran does
! not have unsigned integers of any size, so we can only calculate 19 Disarium numbers
! (unless we start to fiddle with homegrown extended precision integers)
! These 19 numbers all fit in 4 byte integers, so we can limit ourselves to
! signed 4-byte integers, with maximum possible number of digits is 10.

  integer, parameter  :: maxDigs = 10           ! Maximum number of digits
  integer , parameter :: nMax = 19              ! Number of Disarim numbers to print
  integer :: ii                                 ! loop index
  integer :: count                              ! result counter

  ii=0
  count=0

  do while (count .lt. nMax)                    ! finish when count is nMax.
    if (isDisarium (ii)) then                   ! found another result
      count = count + 1
      write (6,'(i0, x)', advance='no')    ii   ! print one by one, but all in 1 line
    end if
    ii = ii + 1
  end do
  write (6,*)   ! terminate line only

  contains

  function isDisarium (n) result(yn)

    integer, intent(in) :: n                    ! decide if n is disarium number
    logical  :: yn                              ! return value, true or false
    integer  :: numD, sum                       ! number of digits, sum of pow(digits,loc)
    integer  :: theDigits (maxDigs)             ! vector with the numD digits of n
    integer  :: jj                              ! loop index
    sum = 0

    numD = getDigits (n, theDigits)             ! Decompose n into numD Digits

    do jj=1, numD
      if (theDigits(jj) .ne. 0) then
        sum = sum + ipow(theDigits(jj), jj)
      endif
    end do
    yn = (sum .eq. n)
  end function isDisarium


  function getDigits (n, d) result (ndigs)

    integer, intent(in)  :: n                   ! decompose this into its digits
    integer, intent(out) :: d(maxDigs)          ! result: digits of n
    integer              :: ndigs               ! return value: number of digits
    integer              :: ii                  ! loop index
    integer              :: localN              ! Local copy of n to work with

    if (n .lt. 10) then   ! Do the trivial case without further calculation
      ndigs = 1
      d(1) = n
      return
    endif

    ndigs = 0
    localN = n
    ! store them right-justified in array d
    do while (localN .gt. 0)
      d(maxDigs - ndigs) = mod(localN, 10)
      ndigs = ndigs + 1
      localN = localN / 10
    end do

    ! Need to shift so that most significant digit appears at d (1)
    do ii = 1, ndigs
      d (ii) = d (maxDigs-ndigs+ii)
    end do

    end function getDigits


  ! Integer power: calculate n ^ pw
  function ipow (n,pw) result (p)
    integer, intent(in) :: n                    ! take this...
    integer, intent(in) :: pw                   ! ... to the power of that
    integer  :: p                               ! Return value
    integer  :: ii                              ! Loop index

    p = 1

    if (pw .lt. 0 .or. n.le. 0) then
      print *, "function ipow(n,p) is only defined for values n,p both >0"
      return
    end if

    do ii=1, pw
      p = p * n
    end do

  end function ipow

end program progDisarium
