! Find Chess960 starting position identifier
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program Chess960
implicit none

! The four starting positions mentioned in the task description.
!
character (len=8), dimension(4), parameter :: SamplePos = ['QNRBBNKR', 'RNBQKBNR', 'RQNBBKRN', 'RNQBBKRN']

integer :: i, id        ! Loop index, result SP-ID

do i=1,4
  id = SpId (SamplePos(i))
  write (*,'("Position ", A, " has Chess960 SP-ID = ", i0)')   SamplePos (i), id
end do

contains

! ====================================================
! Calculate Start Position Id for a given position pos.
! The code strictly follows the algorithm described in
! the Task description, Steps 1...3
! No effort is taken to catch invalid input positions.
! ====================================================
pure function SpId (pos) result (id)

character (len=*), intent(in)  :: pos       ! The input position
integer :: id                               ! The result

integer :: pN(2), nn, ii, p                 ! Positions of the 2 knights, knight number, loop index, position
integer :: N, Q, D, L                       ! Intermediate digits Knight, Queen, Dark and Light Knight

! Initialise knight table using reshape to make gfortran happy. Intel ifx accepts it without the reshape.
integer, dimension(2, 10),parameter  :: knight_table = reshape((/1,2,  &    ! 1-based positions of the Knights
                                                                 1,3,  &
                                                                 1,4,  &
                                                                 1,5,  &
                                                                 2,3,  &
                                                                 2,4,  &
                                                                 2,5,  &
                                                                 3,4,  &
                                                                 3,5,  &
                                                                 4,5/), (/2,10/))
id = 0
! 1. Ignoring the Queen and Bishops, find the positions of the Knights
! --------------------------------------------------------------------
nn = 0
p = 0                                         ! All positions and indices here and below are 1-based !
do ii=1, 8
  if (pos(ii:ii) .eq. 'Q' .or. pos(ii:ii) .eq. 'B') then
    cycle                                     ! we ignore the Queen and the Bishops and go to the next position
  endif
  p = p + 1                                   ! Valid: this is a position in pos if there is no Q and no B
  if (pos(ii:ii) .eq. 'N') then
    nn = nn + 1
    pN(nn) = p
  end if
end do
! Estimate digit N from positions of the 2 knights, using the table
do ii=1, 10
  if (pN(1) .eq. knight_table (1,ii) .and. pN(2) .eq. knight_table (2,ii)) then
    N = ii-1                                  ! N is 0...9 not 1...10
    exit
  end if
end do

! 2. Still ignoring the Bishops, find the position of the Queen in the remaining 6 spaces
! ----------------------------------------------------------------------------------------
p = 0
do ii=1,8
  if (pos(ii:ii) .eq. 'B') then
    ! we ignore all  Bishops:
    cycle
  endif
  p = p + 1
  if (pos(ii:ii) .eq. 'Q') then
    Q = p-1     ! Q is 0...6
  end if
end do

! 3. Finally, find the positions of the two bishops within their respective sets of four like-colored squares
! -----------------------------------------------------------------------------------------------------------
do ii=1,7,2
  ! Dark:
  if (pos(ii:ii) .eq. 'B') then
     D = ii/2   ! gives 0,1,2,3
  endif
  ! Light:
  if (pos(ii+1:ii+1) .eq. 'B') then
    L = ii/2  ! also gives 0,1,2,3
  endif
end do

id = 4*(4*(6*N+Q)+D)+L
end function SpId

end program Chess960
