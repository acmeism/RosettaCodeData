! Modified random distribution
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program modrand
implicit none
integer, parameter :: DP=8                      ! Reals hare Double PRecision here
integer, parameter :: NMAX=100000               ! Generate that many random numbers
integer, parameter :: nHist=21                  ! Number of Histogram Channels
integer, parameter :: histMaxPoint = 80         ! Normalize maximum Histogram count to 80 chars width

real(kind=DP), dimension(0:nHist) :: HLimits    ! the upper limit of each Histogram channel
integer, dimension(nHist) :: Hist               ! THe histogram channels

integer :: ii, jj,                              ! loop indices
integer :: mv, nd                               ! maximum count in all histogram channels
real (kind=DP) :: r                             ! 1 generated random number

call random_seed ()                             ! Initialize random number generator

do ii=0, nHist                                  !Initialize Histogram limits
  HLimits(ii) = real(ii,DP) / real(nHist, DP)
enddo
Hist = 0

do ii=1, NMAX                                   ! Do the generation
  call modifiedRandom (r)
  do jj=1, nHist                                ! Find histogram channel
    if (r .lt. HLimits (jj)) then
      Hist(jj) = Hist(jj) + 1
      exit
    endif
  end do
end do

! Display the histogram: Normalize such that maximum count would display as 80 '*'
mv = maxval(Hist)
write (*,'("---Range---    Count ")')
do ii=1, nHist
  nd = histMaxPoint * real (hist(ii),DP) / real (mv ,DP)    ! Number of stars to show
  ! Top line
  write (*,'(F4.2,"...",F4.2,4X,I5,3x)',advance='no')  HLimits(ii-1), HLimits(ii), hist(ii)

  do jj=1,nd
    write (*,'("*")', advance='no')
  enddo
  write (*,*)
enddo
write (*,'(/,"Total:", 7x,I7)')   NMAX
contains

! =======================================================================
! returns r as modified randum value as described in the task description
! =======================================================================
subroutine modifiedRandom (r)
real(kind=DP), intent(out) :: r
real (kind=DP) :: r1, r2

r = -1._DP
do while (r .lt. 0._DP)
  call random_number (r1)
  call random_number (r2)
  if (r2 < modifier(r1)) r = r1
end do
end subroutine modifiedRandom

! ======================================================
! The modifier function as shown in the task description
! ======================================================
pure function modifier(x) result (returnvalue)
real (kind=DP), intent(in) :: x
real (kind=DP) :: returnvalue

if (x .lt. 0.5_DP) then
  returnvalue = 2.0_DP*(0.5_DP - x)
else
  returnvalue = 2.0_DP*(x - 0.5_DP)
endif
end function modifier

end program modrand
