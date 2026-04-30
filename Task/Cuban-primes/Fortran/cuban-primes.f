! Cuban Prime Numbers
! tested with GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!
! Note that both intel ifx and VSI Fortran do not compile this code because they do not
! support 16-byte-integers.
!
! U.B., September 2025
!

program CubanPrimes
  implicit none

  integer, parameter :: llint=16
  integer, parameter ::strLen = 20

  integer (kind=llint)    :: nc = 0, i=0, di
  character (len=strLen)  :: sdi      ! for formatted output of di

  write (*, *) 'The first 200 cuban prime numbers are:'
  do while (nc .lt. 100001)
    di = diff_cubes(i)
    if (isprime(di)) then
      nc = nc + 1
      if (nc .le. 200)  then
        sdi = GroupedDigits (di, 10)
        write (*, '(A10)', advance='no')  sdi
        if (mod (nc,10)  .eq. 0 ) then
          write (*,*)
        end if
      end if
      if (nc .eq. 100000) then
        sdi = GroupedDigits (di, 18)
        write (*,'(//"The 100000th cuban prime number is: ", A)') sdi
        exit
      end if
    end if
    i = i + 1
  end do


  contains

  !------------------------------------------------
  ! Calculate difference (n+1)³ - n³ = 3n² + 3n + 1
  !------------------------------------------------
  function diff_cubes( n ) result (n3)
    integer (kind=llint),intent(in) ::n
    integer (kind=llint) :: n3
    n3 =  3*n*(n+1) + 1
  end function


  ! ----------------------------------------------------------------
  ! Fortran does not have a way to use locales for output.
  ! Manual insert of separating commas such as 1,345,678 for 1345678
  ! ----------------------------------------------------------------
  function GroupedDigits (n, width) result (outStr)
  integer(kind=llint), intent (in) :: n
  integer :: width
  character (len=width) :: outStr
  character (len=2*strLen) :: workStr
  integer :: ii, jj, cnt, trueLen


  ! Write n into a string, then copy the digits to a second string,
  ! inserting separater after every 3 digits.
  write (workStr, '(i0)') n
  ! Adjust left, then cutoff trailing blanks
  workstr = adjustl (workstr)
  trueLen = len_trim (workStr)

  outStr = ' '
  jj = width
  cnt = 0
  do ii=trueLen, 1, -1                  ! Copy backwards for correct grouping.
    outStr (jj:jj) = workStr (ii:ii)
    jj = jj -1
    cnt = cnt + 1
    ! Insert comma after 3 digits, but only if more digits follow.
    if (mod (cnt, 3) .eq. 0 .and. ii .gt. 1 .and. workStr(ii-1:ii-1) .ne. ' ') then
      outStr (jj:jj) = ','
      jj = jj - 1
    endif
  end do

  end function GroupedDigits






  ! ----------------------------------------
  ! Miller-Rabin test if n is a prime number
  ! ----------------------------------------
  function isPrime(n) result (YN)

  integer(kind=llint), intent(in) ::n
  logical :: YN
  integer (kind=llint) :: ar (5), i

  ! Early return in most trivial cases
  if (n .le. 1) then      ! Too small
    YN=.false.
    return
  endif
  if (n .eq. 2) then      ! 2 is prime
    YN=.true.
    return
  endif
  if (mod (n , 2) .eq. 0) then    ! all other even number are not prime
    YN=.false.
    return
  endif
  if (n .lt. 9) then              ! all odd numbers < 9 are prime
    YN=.true.
    return
  endif
  if (mod (n , 3) .eq. 0) then    ! multiples of 3 aren't prime
    YN=.false.
    return
  endif
  if (mod (n , 5) .eq. 0) then    ! multiples of 5 aren't prime
    YN=.false.
    return
  endif

  ! these 5 bases are required and sufficient to test numbers up to 2,152,302,898,747	
  ar(1) =  2
  ar(2) = 3
  ar(3) = 5
  ar(4) = 7
  ar(5) = 11
  do i = 1, 5
    if (Witness(ar(i), n)) then
      YN=.false.                  ! Not prime
      return
    endif
  end do
  YN= .true.                      ! prime

  end function isPrime

  ! -------------------------------------
  ! helper function for Miller Rabin test
  ! -------------------------------------
  function Witness(a, n) result (YN)

  integer (kind=llint) , intent(in) :: a
  integer (kind=llint)  , intent(in) :: n


  integer (kind=llint) :: t, u, i
  logical :: YN
  integer (kind=llint)  :: xi1, xi2

  t = 0
  u = n - 1
  do while (iand(u , 1_llint) .eq. 0)
    t = t + 1
    u = u / 2
  end do

  xi1 = ModularExp(a, u, n);
  do i = 0, t-1
    xi2 = mod (xi1 * xi1 , n)
    if ((xi2 .eq. 1) .and. (xi1 .ne. 1) .and.  (xi1 .ne. (n - 1))) then
      YN = .true.
      return
    endif
    xi1 = xi2
  end do
  if (xi1 .ne. 1) then
    YN=.true.
  else
    YN = .false.
  endif
  end function Witness

  ! -------------------------------------
  ! helper function for Miller Rabin test
  ! -------------------------------------
  function ModularExp(a, b, n)  result(d)

  integer(kind=llint) , intent(in) :: a,b,n
  integer (kind=llint) :: d
  integer (kind=llint) :: i, k
  d = 1
  k = 0
  do while (ishft (b, -k) .gt. 0)
    k = k + 1
  end do
  do i = k - 1, 0, -1
    d = mod (d*d, n)
    if (iand (ishft (b, -i) , 1_llint) .gt. 0) d = mod (d*a ,n);
  end do

  end function ModularExp


end program
