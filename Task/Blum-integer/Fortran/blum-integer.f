program BlumInteger
  use, intrinsic :: iso_fortran_env, only: int32, int64
  implicit none

  integer(int32), parameter :: LIMIT = 10*1000*1000
  integer(int32), allocatable :: BlumPrimes(:)
  integer(int32), allocatable :: BlumPrimes2(:)
  logical :: BlumField(0:LIMIT)
  integer(int32) :: EndDigit(0:9)
  integer(int64) :: k
  integer(int32) :: n, idx, j, P4n3Cnt,xx,yy
  call system_clock(count=xx)
  call Sieve4n_3_Primes(LIMIT, BlumPrimes2)
!  allocate(blumprimes(0:size(BlumPrimes2)-1))
!   The blumprimes2 array is allocated in the subroutine as a zero based array
! but, the main program doesn't know that and assumes it's 1 based so we allocate
! a zero based array then use move_alloc to correctly resize it a transfer the data
  allocate(blumprimes(0:1))
  call move_alloc(blumprimes2,blumprimes)
  P4n3Cnt = size(BlumPrimes) -1
  print *, 'There are ', CommaUint(int(P4n3Cnt, int64)), ' needed primes 4*n+3 to Limit ', CommaUint(int(LIMIT, int64))
  P4n3Cnt = P4n3Cnt - 1
  print *

  ! Generate Blum-Integers
  BlumField = .false.
  do idx = 0, P4n3Cnt
    n = BlumPrimes(idx)
    do j = idx+1, P4n3Cnt
      k = int(n, int64) * int(BlumPrimes(j), int64)
      if (k > LIMIT) exit
      BlumField(k) = .true.
    end do
  end do
  call system_clock(count=yy)
  print *, 'First 50 Blum-Integers '
  idx = 0
  j = 0
  do
    do while (idx < LIMIT .and. .not. BlumField(idx))
      idx = idx + 1
    end do
    if (idx == LIMIT) exit
    if (mod(j, 10) == 0 .and. j /= 0) print *
    write(*, '(I5)', advance='no') idx
    j = j + 1
    idx = idx + 1
    if (j >= 50) exit
  end do
  print '(//)'

  print *, '               relative occurence of digit'
  print *, '   n.th  |BlumInteger|Digit: 1       3          7          9'
  idx = 0
  j = 0
  n = 0
  k = 26828
  EndDigit = 0
  do
    do while (idx < LIMIT .and. .not. BlumField(idx))
      idx = idx + 1
    end do
    if (idx == LIMIT) exit
    ! Count last decimal digit
    EndDigit(mod(idx, 10)) = EndDigit(mod(idx, 10)) + 1
    j = j + 1
    if (j == k) then
      write(*, '(A10,A1,A11,A1)', advance='no') CommaUint(int(j, int64)), '|', CommaUint(int(idx, int64)), '|'
      write(*, '(F7.3,A4)', advance='no') real(EndDigit(1))/j*100, '%  |'
      write(*, '(F7.3,A4)', advance='no') real(EndDigit(3))/j*100, '%  |'
      write(*, '(F7.3,A4)', advance='no') real(EndDigit(7))/j*100, '%  |'
      write(*, '(F7.3,A2)') real(EndDigit(9))/j*100, '%'
      if (k < 100000) then
        k = 100000
      else
        k = k + 100000
      end if
    end if
    idx = idx + 1
    if (j >= 400000) exit
  end do
  print '(/,a,f8.6,1x,a)', 'Elapsed time = ',(yy-xx)/1000.0,'seconds'
contains

  subroutine Sieve4n_3_Primes(Limit, P4n3)
      use iso_fortran_env
    integer(int32), intent(in) :: Limit
    integer(int32), allocatable, intent(out) :: P4n3(:)
    integer(kind=1), allocatable :: sieve(:)
    integer(int32) :: BlPrCnt, idx, n, j, sieve_size

    sieve_size = (Limit / 3 - 3) / 4 + 1
    allocate(sieve(0:sieve_size-1))
    allocate(P4n3(0:sieve_size-1))

    sieve = 0
    BlPrCnt = 0
    idx = 0
    do
      if (sieve(idx) == 0) then
        n = idx*4 + 3
        P4n3(BlPrCnt) = n
        BlPrCnt = BlPrCnt + 1
        j = idx + n
        if (j > ubound(sieve, 1)) exit
        do while (j <= ubound(sieve, 1))
          sieve(j) = 1
          j = j + n
        end do
      end if
      idx = idx + 1
      if (idx > ubound(sieve, 1)) exit
    end do
    ! Collect the rest
    do idx = idx, ubound(sieve, 1)
      if (sieve(idx) == 0) then
        P4n3(BlPrCnt) = idx*4 + 3
        BlPrCnt = BlPrCnt + 1
      end if
    end do
    P4n3 = P4n3(0:BlPrCnt-1)
  end subroutine Sieve4n_3_Primes

  function CommaUint(n) result(res)
    integer, parameter :: sizer = 30
    integer(int64), intent(in) :: n
    character(:), allocatable :: res
    character(len=sizer) :: temp
    integer :: fromIdx, toIdx, i
    character :: pRes(sizer)

    write(temp, '(I0)') n
    fromIdx = len_trim(temp)
    toIdx = fromIdx - 1
    if (toIdx < 3) then
      res = temp(1:fromIdx)
      return
    end if
    allocate(res, mold=repeat(' ',sizer))
    toIdx = 4*(toIdx / 3) + mod(toIdx, 3) + 1
    pRes = ' '

    do i = 1, fromIdx
      pRes(toIdx) = temp(fromIdx-i+1:fromIdx-i+1)
      toIdx = toIdx - 1
      if (mod(i, 3) == 0 .and. i /= fromIdx) then
        pRes(toIdx) = ','
        toIdx = toIdx - 1
      end if
    end do
    do i = 1,sizer ! Go from character array to string
        res(I:I) = pRes(i)
    end do
!
    res = trim(adjustl(Res))
  end function CommaUint

end program BlumInteger
