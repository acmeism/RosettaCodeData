! Hofstadter Figure-Figure sequences
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!  VSI Fortran x86-64 V8.6-001 does not compile this code
!
!
module modHofstadter
  implicit none
  integer, allocatable :: R(:), S(:)              ! arrays R and S
  integer              :: maxRIdx =0, maxSIdx=0   ! highest index in R and S
  integer              :: capR=0, capS=0          ! Capacity of R and S

  contains

    ! Returns R(n)
    function ffr (n) result(retR)
      integer, intent(in)  :: n
      integer              :: retR

      ! R(n) not yet already memoized?
      if (n .gt. maxRidx) then
        ! fill both R and S up to index n
        call fillRandS (n)
      end if
      retR = R(n)
    end function ffr

    ! Returns S(n)
    function ffs (n) result(retS)
      integer, intent(in)  :: n
      integer              :: retS

      ! S(n) not yet memoized?
      if (n .gt. maxSidx) then
        ! fill both R and S up to index n
        call fillRandS (n)
      end if
      retS = S(n)
    end function ffS


    ! fill arrays R and S up to index n
    subroutine fillRandS (n)
      integer, intent(in)   :: n
      integer               :: ii, jj

      ! calculate values of R between maxRidx+1 up to n
      do ii=maxRidx+1, n
        call pushR (R(ii-1)+S(ii-1))
        ! find next higher value of S not yet in R
        jj=S (maxSidx)+1
        ! Remark: This is admittedly not very efficient.
        !         But first make it work, then make it fast.
        do while (isInR (jj))   ! until a jj found that is not yet in R
          jj = jj + 1
        end do
        call pushS (jj)         ! jj this is the next S
      end do
    end subroutine fillRandS

    ! Return true if value n is stored in array R, otherwise false.
    function isInR (n) result(YN)
    integer, intent(in)   :: n
    logical               :: YN
    integer               :: ii

    do ii=1, maxRidx
      if (R(ii) == n) then
        YN = .true.
        return
      end if
    end do
    YN = .false.

    end function isInR

  ! Change allocated size of array 'var'
    subroutine resize(var, n)
      integer, allocatable, intent(inout) :: var(:)
      integer, allocatable :: tmp(:)
      integer, intent(in)  :: n
      integer :: this_size, new_size

      ! Copy allocated values to temporary, then allocate var with
      ! new size and then copy back saved values.
      if (allocated(var)) then
        this_size = size(var, 1)
        call move_alloc(var, tmp)
      else
        this_size = 0
      end if

      if (n .le. this_size) then
        ! resize not as increase: do nothing,
        Return
      endif

      new_size = n

      allocate(var(new_size))

      if (allocated(tmp)) then
        this_size = min(size(tmp, 1), size(var, 1))
        var(:this_size) = tmp(:this_size)
      end if
    end subroutine resize


    ! append value n as higheast value of R
    subroutine pushR (n)
      integer, intent(in)   :: n

      maxRidx = maxRidx+1
      if (maxRidx .gt. capR) then
        if (capR .eq. 0) then
          allocate (R(1))
          capR = 1
        end if
        do while (capR .lt. maxRidx)
          capr = 2 * capr
          call resize (R, capR)
        end do
      end if
      R(maxRidx ) = n
    end subroutine pushR

    ! append value n as highest value of S
    subroutine pushS (n)
      integer, intent(in) :: n

      maxSidx = maxSidx+1
      if (maxSidx .gt. capS) then
        if (capS .eq. 0) then
          allocate (S(1))
          capS = 1
        end if
        do while (capS .lt.  maxSidx)
          capS = 2 * capS
          call resize  (S, capS)
        end do
      end if
      S(maxSidx ) = n
    end subroutine pushS


end module modHofstadter


program progHofstadter

  use modHofstadter
  implicit none

  integer:: i
  integer :: seen (1000) = 1000*0
  logical :: ok = .true.

  call pushR (1)
  call pushS (2)

  ! As requested for this task, print first 10 values of R
  write (6,'("R(1..10) : ")', advance='no')
  do i=1,9            ! first 9 values in a line (advance=no), each followed by a comma
    write (6,'(I0,",")', advance='no')   ffr(i)
  end do
  write (6,'(i0)') ffr(10)    ! 10th value without comma but with Line termination

  ! calculate highest required R and S
  i = ffr(40)
  i = ffs(960)

  ! count how often values 1...1000 appear in R and S
  do i=1, 40
    seen (r(i)) = seen(r(i)) + 1
  end do
  do i=1, 960
    seen (s(i)) = seen(s(i)) + 1
  end do

  ! all values seen once?
  do i = 1, 1000
    if (seen(i) .ne. 1) then
      ! No: Complain.
      print *, i, ' appears ', seen(i), ' times.'
      ok = .false.
      EXIT
    end if
  end do

  if (ok) then
    write (6,'("all numbers 1...1000 appear exactly once in R(1..40) + S(1..960).")')
  end if

end program progHofstadter
