!
! Kernighans large earthquake problem
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., September 2025
!
program Kerthquake
! Incorporate the file name into the program, (as it is assumed that the program is single use).
character(len=*), parameter  :: filename='data.txt'
integer, parameter :: lun = 10
integer, parameter :: majorQuake = 6                ! THe programm will filter for Strength > this value
character, parameter :: space = char (32)           ! assume ASCII, use numeric values to avoid ...
character, parameter :: tab = char (9)              ! ... editors that convert tabs to multiple spaces
real (kind=8)    :: RichterValue                    ! real(8) represents all 32 bit integer numbers precisely
character (len=100)  :: line                        ! Assume maximum line length is 100

integer :: iostat, trimmedLength, lastWhiteSPace

open (unit=lun, file=filename, form='formatted', status='old', action='read', iostat=iostat)
if (iostat .ne. 0) then                             ! Open error
  print *, 'File ', filename, ' open error'
  stop                                              ! Would be pointless to proceed
endif

do
  read (lun, '(A)', iostat=iostat)    line
  if (iostat .gt. 0) then                           ! Read error
    print *, 'File ', filename, ' Read error'       ! Do not try to silently get away with this error.
    stop                                            ! Force them to fix the error.
  else if (iostat .lt. 0) then                      ! EOF detected: normal condition
    exit
  endif
  trimmedLength = len_trim (line)                   ! Ignore any trailing whitespace
  lastWhiteSpace =  max (index (line(:trimmedLength), space, BACK=.true.),  &
                         index (line(:trimmedLength) ,tab,BACK=.true.))
  if (lastWhiteSpace .gt. 0) then                   ! 0 would mean "no whitespace found"
    read (line(lastWhiteSPace:trimmedLength), *, iostat=iostat)  RichterValue
    if (iostat .ne. 0) then
      print *, 'Eror reading quake strength in line ', line
    endif
    if (RichterValue .gt. majorQuake)   print '(X,A)', line(:trimmedLength)
  endif
end do

end program Kerthquake
