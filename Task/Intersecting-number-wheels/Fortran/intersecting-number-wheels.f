!
! Intersecting number wheels
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!
program NumberWheel

implicit none

! The data structure that describes one Number Wheel
type  :: tWheel
  character :: Name
  character, allocatable , dimension(:)  :: Value
  integer :: ValueArraySize
  integer   :: Position
end type

integer, parameter :: nNumbersToPrint = 20



! Representation of a wheel: 1st character Name, followed by numbers or references of other wheels
! Assuming the numbers on the wheel are 1-digit only.
!
call solve (1,4,['A123'])   ! Number of rows, length of longest string, array of strings

call solve (2, 4, ['A1B2', &
                   'B34 '] )    ! gfortran requires all strings have same length. IFX doesn't.
call solve (2, 4, ['A1DD', &
                   'D678'] )

call solve (3, 4, ['A1BC', &
                   'B34 ', &     ! The trailing blanks will be cutoff befure use.
                   'C5B '] )

contains

  !----------------------------------------------------------------------
  ! print the first 20 numbers returned by the intersecting number wheels
  !----------------------------------------------------------------------
  subroutine solve (n, m, w)
    integer, intent(in) :: n, m                 ! Number of wheels, length of longest descriptor string
    character(len=m), intent(in) :: w (n)       ! Descriptor strings of the wheels

    type (tWheel) , allocatable :: Wheels(:)    ! The n Wheels to work with

    integer :: nWheels                          ! number of intersecting wheels
    integer :: ii, jj                           ! Loop indices
    integer ::  currentWheel=1                  ! Index of the first wheel we're working on
    character :: c (nNumbersToPrint)


    nWheels =  n
    allocate (wheels(n))                        ! Allocate space for the wheels

    do ii=1, nWheels
      call fillWheel (wheels(ii), w(ii)(1:1), w(ii)(2:m))
    enddo

    ! Collect first 'nNumbersToPrint' result for printing
    do ii=1, nNumbersToPrint
      c(ii) = getnextEntry (Wheels, currentWheel)
    end do

    print *, 'Intersecting Number Wheel group:'
    do ii=1, nWheels
      print *,'  ', Wheels(ii)%Name, ': ', (Wheels(ii)%Value(jj), ' ',jj=1,Wheels(ii)%ValueArraySize)
    end do
    print *,'  Generates:'
    print *,'    ', (c(ii),' ', ii=1,nNumbersToPrint), '...'
    print * ! empty line after each test case
  end subroutine solve

  ! ------------------------------------------------
  ! Get next due number from the intersecting wheels
  ! ------------------------------------------------
  recursive function getnextEntry (Wheels, currentWheel) result (c)
    type (tWheel) , allocatable, intent(inout)  :: wheels(:)
    integer , intent(in) :: currentWheel

    character :: c
    integer:: idx, ii

    ! Find next index in current wheel. Start over if end of value array or '-' reached
    idx = WHeels (currentWheel)%position + 1
    if (idx .le. Wheels(currentWheel)%ValueArraySize) then
      if (Wheels(currentWheel)%value (idx) .eq. ' ') then   ! Behind last valid character
        idx = 1
      endif
    else    ! Behind End of array
      idx = 1
    end if
    Wheels (currentWheel)%position = idx
    c = Wheels (currentWheel)%value (idx)
    if (c .ge. 'A' .and. c .le. 'Z') then
      ! Name at current position
      do ii = 1, size(wheels)
        if (wheels(ii)%name .eq. c) then
          c = getnextEntry (Wheels, ii)
          exit
        end if
      end do
    endif

    end function getnextEntry

  ! ----------------------------------------------------
  ! Fill the Wheel structure with values in the argument
  ! ----------------------------------------------------
  subroutine  fillWheel (w, n, v)

  type (tWheel), intent(inout) :: w           ! The data structure to fill
  character, intent(in)  :: n                 ! 'Name' of the wheel
  character(len=*), intent(in)  ::v           ! the values on the wheel

  integer :: ii                               ! Loop index


  w%Name = n

  w%ValueArraySize = len_trim(v)              ! Cutoff the trailing blanks

  allocate (w%value(w%ValueArraySize))
  do ii=1, w%ValueArraySize
    w%value(ii)  = v (ii:ii)
  end do
  w%Position = 0

end subroutine fillWheel

end program NUmberWheel
