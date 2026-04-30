! Fixed length records
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! but not VSI Fortran x86-64 V8.7-001 because that compiler does not accept
! the option "access='stream'" in the OPEN statement.
!
program fixedRecord

implicit none

integer, parameter :: lunin=10, lunout=20         ! Logical units for iinput and output
integer, parameter :: rl=80                       ! Fixed Record length
character (len=*), parameter :: infilename = 'infile.dat', outfilename='outfile.dat'
integer :: ios                                    ! Status of I/O operations
character (len=rl)  :: line                       ! 1 record to be read

! The input file does not contain any marks such as LF or CR that indicate the end of each record.
! So the fixed record size is merely an agreement between the writer of the file and the reading program
! In fact it is an endless stream of bytes that (again by agreement) happen to be ASCII characters, and
! we have to read them in chunks of 80 bytes.
! reading 'unformatted' from a 'stream' is what we need to do here.
open (unit=lunin, form='unformatted', access='stream', file=infilename, status='old', action='read',  iostat=ios)
if (ios .ne. 0) then
  print *, 'Error opening file ', infilename
  stop
endif

! The output file that has the same agreement: a very long stream of characters.
! Again, we write the modified 80-byte-records 'unformatted' to the 'stream' file.
! status='unknown': overwrite the output file if it exists already, otherwise create it.
open (unit=lunout, form='unformatted',access='stream', file=outfilename, status='unknown', action='write',  iostat=ios)
if (ios .ne. 0) then
  print *, 'Error opening file ', outfilename
  stop
endif

! Start an endless I/O loop. THis terminmates either when an error occurs or when EOF is detected.
do
  read(lunin, iostat=ios)   line
   if (ios .lt. 0) exit                           ! EOF on input, silently terminate
  if (ios .gt. 0) then                            ! Error, terminate after error message
    print *, 'Error reading file ', infilename
    exit
  endif
  write (lunout, iostat=ios)   reverse(line)
  if (ios .ne. 0) then                            ! Error, terminate after error message
    print *, 'Error writing file ', outfilename
    exit
  endif
enddo

contains

! =========================================================================
! Return the characters of a text string in inverse order of the characters
! =========================================================================
pure function reverse (text) result (txet)

character (len=*), intent(in) :: text             ! Input string
character (len=len(text)) :: txet                 ! Result: reversed text
integer :: ii, l                                  ! Loop index, text string length

l = len(text)                                     ! expect 80 but prpare for error
do ii= l, 1, -1
  txet(l-ii+1:l-ii+1) = text(ii:ii)
end do

end function reverse

end program fixedRecord
