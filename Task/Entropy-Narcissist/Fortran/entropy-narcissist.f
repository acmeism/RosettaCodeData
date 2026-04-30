! Entropy/Narcissist
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
!
program EntropyNarc
implicit none
integer, parameter :: DP=8                          ! Real kind for double precision
integer , parameter :: srcLen=200                   ! Must be Longer than the longest source line
integer, parameter  :: lunin=10
character (len=*), parameter :: sourceFileName = 'EntropyNarc.f90'
real (kind=DP),  dimension(255) :: CharMultiplicity
real(kind=DP) :: tot
real(kind=DP) :: entropy
character (len=srcLen)   :: line
integer :: nLines
integer :: l
integer :: ios
integer :: ii

open (unit=lunin, file=sourceFileName, status='old', action='read', iostat=ios)
if (ios .ne.  0) then
  print *, "Error opening file ", sourceFileName
  stop
end if

CharMultiplicity = 0
nLines = 0
tot = 0
! Read the entire file, line by line, and analyse for multiplicity of characters
!
do            ! This endless loops terminates on READ error or, more normal, EOF on input.
  read (lunin,'(A)', iostat=ios)    line
  if (ios .lt. 0)    exit
  if (ios .ne. 0) then
    print *, 'Read error # ', ios, ' while reading file ', sourceFileName
    stop
  endif
  l = len_trim (line)
  if (l .gt. 0) nLines = nLines + 1
  tot = tot + l
  do ii=1,l
    CharMultiplicity (ichar(line(ii:ii))) = CharMultiplicity (ichar(line(ii:ii))) + 1
  enddo
enddo

Entropy = 0
do ii=1,255
  if (CharMultiplicity (ii) .ge. 1) then    ! Not useful to calculate log(0)
    Entropy = Entropy - CharMultiplicity (ii) / tot * log2(CharMultiplicity (ii) / tot);
  end if
enddo
write (*,'("The Fortran source file has ", i0, " non-empty lines with ", i0, " characters, Entropy = ", F10.7)') nLines, int(tot), Entropy
contains

! =================================================
! Helper, Fortran knows LOG and LOG10 but not LOG2.
! Just a trivial base change
! =================================================
function log2 (x) result (r)
real (kind=8), intent(in) ::x
real (kind=8) ::r
r = log(x) / log(2.)
end function log2
end program EntropyNarc
