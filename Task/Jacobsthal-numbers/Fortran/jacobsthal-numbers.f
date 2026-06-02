!
! Jacobsthal numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., May 2026
!
program Jacobsthal

implicit none
integer, parameter :: tInt=8                ! We need to calculate with large integers
integer, parameter :: nJacob=30, nJacobLucas=30, nJacobOblong=20, nJacobPrime=10

call printJacob       (nJacob)
call printJacobLucas  (nJacobLucas)
call printJacobOblong (nJacobOblong)
call printJacobPrime  (nJacobPrime)

contains

! ==========================================
! Calculate and print 'n' Jacobsthal numbers
! ==========================================
subroutine printJacob (n)
integer, intent(in) :: n
integer(kind=tInt) :: j
integer :: ii

write (*,'("First ", i0, " Jacobsthal numbers:")') n

do ii=0,n-1
  j = (2_tInt**ii - (-1)**ii) / 3_tInt            ! Use formula as gicen in the task description
  write (*,'(i15)', advance='no') j
  if (mod (ii,5) .eq. 4 .or. ii .eq. n-1) then    ! Write 5 J-Numbers in one line,
    write (*,*)                                   ! then terminate line
  endif
end do

end subroutine printJacob


! ================================================
! Calculate and print 'n' Jacobsthal-Lucas numbers
! ================================================
subroutine printJacobLucas (n)
integer, intent(in) :: n
integer(kind=tInt) :: j
integer :: ii

write (*,'(/"First ", i0, " Jacobsthal-Lucas numbers:")') n
do ii=0,n-1
  j = 2_tInt**ii + (-1)**ii
  write (*,'(i15)', advance='no') j
  if (mod (ii,5) .eq. 4 .or. ii .eq. n-1) then
    write (*,*)
  endif
end do
end subroutine printJacobLucas


! =================================================
! Calculate and print 'n' Jacobsthal oblong numbers
! =================================================
subroutine printJacobOblong (n)
integer, intent(in) :: n
integer(kind=tInt) :: j
integer :: ii

write (*,'(/"First ", i0, " Jacobsthal oblong numbers:")') n
do ii=0,n-1
  j = ((2_tInt**ii - (-1)**ii) / 3_tInt) * ((2_tInt**(ii+1) - (-1)**(ii+1)) / 3_tInt)
  write (*,'(i15)', advance='no') j
  if (mod (ii,5) .eq. 4 .or. ii .eq. n-1) then
    write (*,*)
  endif
end do

end subroutine printJacobOblong

! ================================================
! Calculate and print 'n' Jacobsthal prime numbers
! ================================================
subroutine printJacobPrime (n)
integer, intent(in) :: n
integer(kind=tInt) :: j
integer :: ii, count

write (*,'(/"First ", i0, " Jacobsthal Prime numbers:")') n
ii = 0
count =  0
! loop until required number of Jacobsthal prime numbers reached, with manual increment of ii
do while (count .lt. n)
  j = ((2_tInt**ii - (-1)**ii) / 3_tInt)
  if (isPrime (j)) then                       ! If and only if its prime, print it
    write (*,'(i15)', advance='no') j
    if (mod (count,5) .eq. 4 .or. count .eq. n) then
      write (*,*)
    endif
    count = count + 1
  endif
  ii = ii + 1
end do
end subroutine printJacobPrime


  ! ----------------------------------------
  ! Miller-Rabin test if n is a prime number
  ! ----------------------------------------
  function isPrime(n) result (YN)

  integer(kind=tInt), intent(in) ::n
  logical :: YN
  integer (kind=tInt) :: ar (9), i

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


  if (n .lt. 2047	) then
    ar(1) = 2
    if (Witness(ar(1), n)) then
      YN=.false.                  ! Not prime
      return
    endif
  else if (n .lt. 1373653) then
    ar(1) =  2
    ar(2) = 3
    do i = 1, 2
      if (Witness(ar(i), n)) then
        YN=.false.                  ! Not prime
        return
      endif
    end do
  else  if (n .lt. 2152302898747_tInt) then

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
  else if (n .lt. 3825123056546413051_tInt) then
    ! these bases are sufficient for numbers up to 3.825.123.056.546.413.051
    ! 2, 3, 5, 7, 11, 13, 17, 19, 23
    ar(1) = 2
    ar(2) = 3
    ar(3) = 5
    ar(4) = 7
    ar(5) = 11
    ar(6) = 13
    ar(7) = 17
    ar(8) = 19
    ar(9) = 23
    do i=1,9
      if (Witness(ar(i), n)) then
        YN=.false.                  ! Not prime
        return
      endif
    enddo
  endif

  YN= .true.                      ! prime

  end function isPrime

  ! -------------------------------------
  ! helper function for Miller Rabin test
  ! -------------------------------------
  function Witness(a, n) result (YN)

  integer (kind=tInt) , intent(in) :: a
  integer (kind=tInt)  , intent(in) :: n


  integer (kind=tInt) :: t, u, i
  logical :: YN
  integer (kind=max(8,tInt))  :: xi1, xi2

  t = 0
  u = n - 1
  do while (iand(u , 1_tInt) .eq. 0)
    t = t + 1
    u = u / 2
  end do

  xi1 = ModularExp(a, u, n)
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
  !
  ! (a^b) mod n
  !
  integer(kind=tInt) , intent(in) :: a,b,n
  integer (kind=tInt) :: d
  integer (kind=tInt) :: i, k
  d = 1
  k = 0
  do while (ishft (b, -k) .gt. 0)
    k = k + 1
  end do
  do i = k - 1, 0, -1
    d = mod (d*d, n)
    if (iand (ishft (b, -i) , 1_tInt) .gt. 0) d = mod (d*a ,n);   ! OVERFLOW HAPPENS in d*a!
  end do

  end function ModularExp

end program Jacobsthal
