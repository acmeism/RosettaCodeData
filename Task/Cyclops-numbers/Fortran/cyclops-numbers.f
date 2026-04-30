!
! Cyclops Numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! Original Pascal code converted to Fortran
! U.B., October 2025
!==============================================================================

module CyclopsNumbers
  implicit none

! Constants
  integer, parameter :: BIGLIMIT = 10000000      ! Upper limit for number search
  integer, parameter :: MAX_DIGITS = 10          ! Maximum digits in base-9 representation

  ! Type for numbers in base-9 representation
  type Num9
    integer :: nmdgts(0:MAX_DIGITS)              ! Digits in base-9 (0-8)
    integer :: nmMaxDgtIdx                       ! Highest digit index used
    integer(kind=8) :: nmNum                     ! Actual numerical value
  end type Num9

  ! Type for cyclops numbers (left + zero + right parts)
  type CyclopsNum
    type(Num9) :: cnRight, cnLeft                ! Right and left parts around zero
    integer(kind=8) :: cnNum                     ! Complete cyclops number
    integer :: cndigits                          ! Number of digits in each side
    integer :: cnIdx                             ! Index of cyclops number
  end type CyclopsNum

  ! Global arrays for precomputed values
  integer(kind=8) :: cnMin(0:15)                 ! Minimum values for digit counts
  integer(kind=8) :: cnPow10Shift(0:15)          ! Powers of 10 for shifting
  integer(kind=8) :: cnPow9(0:15)                ! Powers of 9 for indexing

  ! Dynamic array to store found cyclops numbers
  integer(kind=8), allocatable :: Cyclops(:)

contains

  !============================================================================
  ! Initialize precomputed arrays for minimum values and powers
  ! cnMin:     (0, 1, 11, 111, 1111, ...) - minimum values for n-digit numbers
  ! cnPow10Shift: (100, 1000, 10000, ...) - powers of 10 for position shifting
  ! cnPow9:    (1, 9, 81, 729, ...)       - powers of 9 for base conversion
  !============================================================================
  subroutine InitCnMinPow()
    integer :: i
    integer(kind=8) :: min_val, pow, pow9

    min_val = 0
    pow = 100
    pow9 = 1

    do i = 0, 15
      cnMin(i) = min_val
      min_val = 10 * min_val + 1                    ! Build numbers like 1, 11, 111, ...
      cnPow10Shift(i) = pow
      pow = pow * 10                                ! Next power of 10
      cnPow9(i) = pow9
      pow9 = pow9 * 9                               ! Next power of 9
    end do
  end subroutine InitCnMinPow

  !============================================================================
  ! Reset a Num9 type to minimum value for given digit count
  ! @param tn: Num9 object to clear
  ! @param idx: Digit count index
  !============================================================================
  subroutine  ClearNum9 (tn, idx)
    type(Num9), intent(out) :: tn
    integer, intent(in) :: idx
    integer :: i

    tn%nmdgts = 0                                   ! Clear all digits
    tn%nmMaxDgtIdx = 0                              ! Reset max digit index
    tn%nmNum = cnMin(idx + 1)                       ! Set to minimum value
  end subroutine ClearNum9

  !============================================================================
  ! Initialize a cyclops number to starting state
  ! @param cn: CyclopsNum object to initialize
  !============================================================================
  subroutine InitCycNum(cn)
    type(CyclopsNum), intent(out) :: cn

    cn%cndigits = 0                                 ! Start with 0 digits each side
    call ClearNum9(cn%cnLeft, 0)                    ! Clear left part
    call ClearNum9(cn%cnRight, 0)                   ! Clear right part
    cn%cnNum = 0                                    ! Zero value
    cn%cnIdx = 0                                    ! Start index
  end subroutine InitCycNum

  !============================================================================
  ! Increment a base-9 number, handling carry-over
  ! @param tn: Num9 object to increment
  !============================================================================
  subroutine IncNum9(tn)
    type(Num9), intent(inout) :: tn
    integer :: idx, fac, n, i

    idx = 0
    fac = 1
    n = tn%nmdgts(0) + 1                           ! Increment least significant digit
    tn%nmNum = tn%nmNum + 1                        ! Increment numerical value

    ! Handle carry-over propagation
    do
      if (n < 9) exit                              ! No carry-over needed

      ! Carry-over occurs
      tn%nmNum = tn%nmNum + fac                    ! Adjust numerical value
      tn%nmdgts(idx) = 0                           ! Reset current digit
      idx = idx + 1                                ! Move to next digit
      fac = fac * 10                               ! Increase factor for numerical adjustment

      if (idx > MAX_DIGITS) exit                   ! Check bounds
      n = tn%nmdgts(idx) + 1                       ! Get next digit + 1
    end do

    ! Store final digit value
    if (idx <= MAX_DIGITS) then
      tn%nmdgts(idx) = n
      if (tn%nmMaxDgtIdx < idx) then
        tn%nmMaxDgtIdx = idx                       ! Update max digit index if needed
      end if
    end if
  end subroutine IncNum9

  !============================================================================
  ! Generate the next cyclops number in sequence
  ! @param cycnum: Current cyclops number to advance
  !============================================================================
  subroutine NextCycNum(cycnum)
    type(CyclopsNum), intent(inout) :: cycnum

    if (cycnum%cnIdx /= 0) then
      ! Normal case: increment from previous number
      call IncNum9(cycnum%cnRight)                 ! Increment right part

      ! Check if right part overflowed (needs more digits)
      if (cycnum%cnRight%nmMaxDgtIdx > cycnum%cndigits) then
        call ClearNum9(cycnum%cnRight, cycnum%cndigits)  ! Reset right to minimum
        call IncNum9(cycnum%cnLeft)                ! Increment left part

        ! Check if left part overflowed (needs more digits)
        if (cycnum%cnLeft%nmMaxDgtIdx > cycnum%cndigits) then
          cycnum%cndigits = cycnum%cndigits + 1    ! Increase digit count
          call ClearNum9(cycnum%cnLeft, cycnum%cndigits)   ! Reset left
          call ClearNum9(cycnum%cnRight, cycnum%cndigits)  ! Reset right
          if (cycnum%cndigits > MAX_DIGITS) then
            cycnum%cndigits = MAX_DIGITS           ! Enforce maximum
          end if
        end if
      end if

      ! Reconstruct complete cyclops number: left * 10^(digits+1) + right
      cycnum%cnNum = cycnum%cnLeft%nmNum * cnPow10Shift(cycnum%cndigits) + cycnum%cnRight%nmNum
      cycnum%cnIdx = cycnum%cnIdx + 1
    else
      ! Special case: first cyclops number
      cycnum%cnNum = 101
      cycnum%cnIdx = 1
    end if
  end subroutine NextCycNum


  !============================================================================
  ! Make a complete Palindromic Cyclops number when left half is already setup.
  ! Argument is already initialized to have its left half setup as needed.
  ! Fill digits of right half in reversed order.
  ! @param cycnum: half-filled Cyclops number to be completed as palindrome.
  !============================================================================

  subroutine MakePalinCycNum (cycnum)
    type(CyclopsNum), intent(inout) :: cycnum

    ! make right to have reversed digits of left
    integer :: n,dgt
    integer :: i,j

    n = 0
    i = 0
    do  j = cycnum%cnDigits, 0 , -1
      dgt = cycnum%cnLeft%nmdgts(i)
      cycnum%cnRight%nmdgts(j) = dgt
      n = 10*n+(dgt+1)
      i = i + 1
    end do
    cycnum%cnRight%nmNum = n
    cycnum%cnNum = cycnum%cnLeft%nmNum*cnPow10Shift(cycnum%cndigits)+n
  end subroutine MakePalinCycNum



  !============================================================================
  ! Increment left half of a Cyclops number, handling carry-over
  !============================================================================

  subroutine  IncLeftCn( cn )

    type(CyclopsNum), intent(inout) :: cn

    ! set right digits to minimum
    call ClearNum9 (cn%cnRight,cn%cndigits)
    ! increment left digits
    call IncNum9 (cn%cnLeft)
    ! One more digit in left half?
    if (cn%cnLeft%nmMaxDgtIdx > cn%cndigits) then   ! left has more digits than before?
      cn%cndigits = cn%cndigits + 1                 ! Increment for entire Cyclops number
      call ClearNum9(cn%cnLeft,cn%cndigits)         ! Set left to minimum for new number of digits
      call ClearNum9(cn%cnRight,cn%cndigits)        ! Set right to minimum for new number of digits
      if (cn%cndigits>MAX_DIGITS)  then
        cn%cndigits = MAX_DIGITS
      endif
    endif
    cn%cnNum = cn%cnLeft%nmNum*cnPow10Shift(cn%cndigits)+cn%cnRight%nmNUm
  end subroutine  IncLeftCn

  !============================================================================
  ! Convert a zero-based index to the corresponding cyclops number
  ! Uses combinatorial counting based on digit positions in base-9
  ! @param n: Zero-based index
  ! @return: Corresponding cyclops number
  !============================================================================
  function IndexToCyclops(n) result(result_cn)
    integer(kind=8), intent(in) :: n
    type(CyclopsNum) :: result_cn
    integer :: dgtCnt, i
    integer(kind=8) :: p9, q, num, local_n

    call InitCycNum(result_cn)
    if (n == 0) return                             ! Index 0 returns initialized (0)

    result_cn%cnIdx = n
    dgtCnt = 0
    local_n = n

    ! Determine number of digits needed
    do
      p9 = cnPow9(dgtCnt) * cnPow9(dgtCnt)         ! Combinations for dgtCnt digits
      if (local_n < p9) exit                       ! Found correct digit count
      local_n = local_n - p9                       ! Subtract counted combinations
      dgtCnt = dgtCnt + 1                          ! Try next digit count
      if (dgtCnt > 10) exit                        ! Safety limit
    end do

    dgtCnt = dgtCnt - 1                            ! Adjust to actual digit count

    ! Process right digits (convert from base-9 to base-10)
    result_cn%cnRight%nmMaxDgtIdx = dgtCnt
    do i = 0, dgtCnt
      q = local_n / 9                              ! Integer division
      result_cn%cnRight%nmdgts(i) = local_n - 9 * q  ! Remainder gives base-9 digit
      local_n = q                                  ! Continue with quotient
    end do

    ! Convert base-9 digits to base-10 number (adding 1 to each digit)
    num = 0
    do i = dgtCnt, 0, -1                           ! Most significant digit first
      num = num * 10 + result_cn%cnRight%nmdgts(i) + 1
    end do
    result_cn%cnRight%nmNum = num
    result_cn%cnNum = num                          ! Temporary: only right part

    ! Process left digits (same algorithm)
    result_cn%cnLeft%nmMaxDgtIdx = dgtCnt
    do i = 0, dgtCnt
      q = local_n / 9
      result_cn%cnLeft%nmdgts(i) = local_n - 9 * q
      local_n = q
    end do

    ! Convert left digits to base-10 number
    num = 0
    do i = dgtCnt, 0, -1
      num = num * 10 + result_cn%cnLeft%nmdgts(i) + 1
    end do
    result_cn%cnLeft%nmNum = num

    ! Combine left and right with zero in middle: left * 10^(dgtCnt+1) + right
    result_cn%cnNum = result_cn%cnNum + num * cnPow10Shift(dgtCnt)
    result_cn%cndigits = dgtCnt
  end function IndexToCyclops

  !============================================================================
  ! Display cyclops numbers in formatted columns
  ! @param cl: Array of cyclops numbers
  ! @param colw: Column width for formatting
  ! @param colc: Number of columns per row
  !============================================================================
  subroutine Out_Cyclops(cl, colw, colc)
    integer(kind=8), intent(in) :: cl(:)
    integer, intent(in) :: colw, colc
    integer :: i, n
    character (len=50) :: colFormat

    n = size(cl)
    if (n > 100) n = 100

    ! Create suitable format string to nicely printout columns using colw as width
    write (colformat, '("(I", I0, " )" )')   colw

    ! Print all "n=size(cl)" Numbers of array cl
    do i = 1, n
      write(*, colformat, advance='no') cl(i)       ! Print number using calculated format string
      if (mod(i, colc) == 0) then
        write(*, *)                                 ! New line after colc numbers
      else
        write(*, '(A)', advance='no') ' '          ! Space between numbers
      end if
    end do

    ! Terminate line if incomplete
    if (mod(i, colc) /= 0) write(*, *)
  end subroutine Out_Cyclops

  !============================================================================
  ! Check if a number is prime (simple trial division)
  ! @param n: Number to check
  ! @return: .true. if prime, .false. otherwise
  !============================================================================
  logical function isPrime(n)
    integer(kind=8), intent(in) :: n
    integer(kind=8) :: p, q

    ! Handle small numbers and simple cases
    if (n <= 1) then
      isPrime = .false.
      return
    end if

    if (n == 2 .or. n == 3 .or. n == 5) then
      isPrime = .true.
      return
    end if

    ! Even numbers and multiples of 3
    if (mod(n, 2) == 0 .or. mod(n, 3) == 0) then
      isPrime = .false.
      return
    end if

    ! Trial division for remaining numbers
    p = 5
    do
      q = n / p
      if (n - q * p == 0) then                     ! Divisible by p
        isPrime = .false.
        return
      end if
      p = p + 2                                    ! Next odd number

      q = n / p
      if (n - q * p == 0) then                     ! Divisible by p+2
        isPrime = .false.
        return
      end if

      if (q < p) exit                              ! No need to check further
      p = p + 4                                    ! Skip to next candidate
    end do

    isPrime = .true.                               ! No divisors found
  end function isPrime

  !============================================================================
  ! Generate the first 'cnt' basic cyclops numbers
  ! @param cnt: Number of cyclops numbers to generate
  ! @return: Last cyclops number generated (for continuation)
  !============================================================================
  function FirstCyclops(cnt) result(result_cn)
    integer, intent(in) :: cnt
    type(CyclopsNum) :: result_cn
    integer :: i

    ! Allocate storage for results
    if (allocated(Cyclops)) deallocate(Cyclops)
    allocate(Cyclops(cnt))

    i = 1
    call InitCycNum(result_cn)

    ! Generate requested number of cyclops numbers
    do while (i <= cnt)
      Cyclops(i) = result_cn%cnNum
      i = i + 1
      call NextCycNum(result_cn)
    end do

    ! Continue until beyond BIGLIMIT for reporting
    do while (result_cn%cnNum <= BIGLIMIT)
      call NextCycNum(result_cn)
    end do
  end function FirstCyclops

  !============================================================================
  ! Generate the first 'cnt' prime cyclops numbers
  ! @param cnt: Number of prime cyclops numbers to generate
  ! @return: Last prime cyclops number with updated index
  ! Algorithm as in function FirstCyclops, but check for each generated
  ! Cyclops number if its prime.
  !============================================================================
  function FirstPrimeCyclops(cnt) result(result_cn)
    integer, intent(in) :: cnt
    type(CyclopsNum) :: result_cn
    integer :: i

    if (allocated(Cyclops)) deallocate(Cyclops)
    allocate(Cyclops(cnt))

    i = 1
    call InitCycNum(result_cn)

    do while (i <= cnt)
      if (isPrime(result_cn%cnNum)) then    ! only consider prime Cyclops numbers
        Cyclops(i) = result_cn%cnNum
        i = i + 1
      end if
      call NextCycNum(result_cn)
    end do


    ! Continue until prime Cyclops number is beyond BIGLIMIT for reporting
    do
      if (isPrime(result_cn%cnNum)) then
        result_cn%cnIdx = i ! result_cn%cnIdx + 1
        if (result_cn%cnNum .gt. BIGLIMIT) exit
        i = i + 1
      end if
      call NextCycNum(result_cn)
    end do
  end function FirstPrimeCyclops



  !============================================================================
  ! Generate the first 'cnt' prime blind cyclops numbers
  ! @param cnt: Number of prime cyclops numbers to generate
  ! @return: Last prime cyclops number with updated index
  ! Algorithm as in function FirstCyclops, but check for each generated
  ! Cyclops number if its prime, then construct blind number from this, and
  ! check again if result is prime as well.
  !============================================================================
  function FirstPrimeBlindCyclops(cnt) result(result_cn)
    integer, intent(in) :: cnt
    type(CyclopsNum) :: result_cn
    integer :: i
    integer (kind=8) :: n

    if (allocated(Cyclops)) deallocate(Cyclops)
    allocate(Cyclops(cnt))

    i = 1
    call InitCycNum(result_cn)

    do while (i <= cnt)
      if (isPrime(result_cn%cnNum)) then

        n = result_cn%cnRight%nmnum
        if (result_cn%cndigits .gt. 0) then
          n = n + result_cn%cnLeft%nmnum*cnPow10Shift(result_cn%cndigits-1)
        else
          n = n + result_cn%cnLeft%nmnum*10
        endif
        if (isPrime (n)) then
         Cyclops(i) =result_cn%cnNum
          i = i + 1
         endif
      end if
      call NextCycNum(result_cn)
    end do

    do
      if (isPrime(result_cn%cnNum)) then
        n = result_cn%cnRight%nmnum
        if (result_cn%cndigits .gt. 0) then
          n = n + result_cn%cnLeft%nmnum*cnPow10Shift(result_cn%cndigits-1)
        else
          n = n + result_cn%cnLeft%nmnum*10
        endif
        if (isPrime (n)) then
          result_cn%cnIdx = i
          if (result_cn%cnNum .gt. BIGLIMIT) exit
          i = i + 1
        end if
      end if
      call NextCycNum(result_cn)
    end do
  end function FirstPrimeBlindCyclops

  !============================================================================
  ! Generate the first 'cnt' prime palindromic cyclops numbers
  ! @param cnt: Number of prime palindromic cyclops numbers to generate
  ! @return: Last prime cyclops number with updated index
  ! Algorithm: directly create palindromic cyclops numbers and look for primes.
  !============================================================================
  function FirstPrimePalindromicCyclops(cnt) result(result_cn)
    integer, intent(in) :: cnt
    type(CyclopsNum) :: result_cn
    integer :: i
    integer (kind=8) :: n

    if (allocated(Cyclops)) deallocate(Cyclops)
    allocate(Cyclops(cnt))

    i = 1
    call InitCycNum(result_cn)

    do while (i <= cnt)
      call MakePalinCycNum (result_cn)      ! Complete prepare Cyclops number to a palindrome
      if (isPrime(result_cn%cnNum)) then    ! Consider only if its prime.
          Cyclops(i) =result_cn%cnNum
          i = i + 1
      end if
      call IncLeftCn (result_cn)            ! Next one.

      ! Last digit cannot be even because we need only prime numbers
      do while  (result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1 .ne. 1 .AND. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1 .ne. 3 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 5 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 7 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 9)
        call IncLeftCn(result_cn)
      end do
    end do

    do
      call MakePalinCycNum (result_cn)
      if (isPrime(result_cn%cnNum)) then
          result_cn%cnIdx = i
          if (result_cn%cnNum .gt. BIGLIMIT) exit
          i = i + 1
      end if
      call IncLeftCn (result_cn)

      do while  (result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1 .ne. 1 .AND. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1 .ne. 3 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 5 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 7 .and. &
        result_cn%cnLeft%nmdgts(result_cn%cnDigits)+1  .ne. 9)
        call IncLeftCn(result_cn)
      end do
    end do

  end function FirstPrimePalindromicCyclops

end module CyclopsNumbers

program main
  use CyclopsNumbers
  implicit none

  type(CyclopsNum) :: cycnum
  integer :: cnt
  integer(kind=8) :: i, large_cnt

  call InitCnMinPow()

  ! First 50 cyclops numbers
  cnt = 50
  write(*, "( 'The first ', I0, ' cyclops numbers are:')") cnt
  cycnum = FirstCyclops(cnt)
  call Out_Cyclops(Cyclops, 5, 10)
  write(*, "('First cyclops number > ', I0, ' is ', I0, ' at 1-based index ', I0, / )")  BIGLIMIT, cycnum%cnNum, cycnum%cnIdx

  ! First 50 prime cyclops numbers
  cnt = 50
  write(*,  "('The first ', I0, ' prime cyclops numbers are:')") cnt
  cycnum = FirstPrimeCyclops(cnt)
  call Out_Cyclops(Cyclops, 7, 10)
  write(*, "('First prime cyclops number > ', I0, ' is ', I0, ' at 1-based index ', I0, / )")  BIGLIMIT, cycnum%cnNum, cycnum%cnIdx
  write(*, *)


! First 50 prime blind cyclops numbers
  cnt = 50
  write(*,  "('The first ', I0, ' prime blind cyclops numbers are:')") cnt
  cycnum = FirstPrimeBlindCyclops(cnt)
  call Out_Cyclops(Cyclops, 7, 10)
  write(*, "('First prime blind cyclops number > ', I0, ' is ', I0, ' at 1-based index ', I0, / )")  BIGLIMIT, cycnum%cnNum, cycnum%cnIdx

! First 50 prime palindromic cyclops numbers
  cnt = 50
  write(*, "( 'The first ', I0, ' prime palindromic cyclops numbers are:')") cnt
  cycnum = FirstPrimePalindromicCyclops(cnt)
  call Out_Cyclops(Cyclops, 7, 10)
  write(*, "('First palindromic prime cyclops number > ', I0, ' is ', I0, ' at 1-based index ', I0, / )")  BIGLIMIT, cycnum%cnNum, cycnum%cnIdx




  ! Additional test cases for large indices
  write(*, '(A/)') 'Demonstrating Cyclops calculation for large indices:'
  write(*, '(A)') '            Index     Cyclop Number    Calculated Cyclop Number '
  large_cnt = 100
  do while (large_cnt <= 1000000000000000_8)
    write(*, '(I17, A)', advance='no') large_cnt, '     '
    if (large_cnt <= 10000) then    ! For small index values evaluate Cyclops number sequentially
      call InitCycNum(cycnum)
      do i = 1, large_cnt-1         ! at index 1 we have 0, is already there by initialisation
        call NextCycNum(cycnum)     ! hence we need only (large_cnt-1) next sequence elements
      end do
      write(*, '(I7)', advance='no') cycnum%cnNum
    else
      write (*, '("       ")', advance='no')
    end if
    cycnum = IndexToCyclops(large_cnt-1)      ! direct calculation, for comparison when index is small
    write(*, *) ' ', cycnum%cnNum
    large_cnt = large_cnt * 10              ! next order of magnitude
  end do

end program main
