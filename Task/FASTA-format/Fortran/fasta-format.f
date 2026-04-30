! FASTA format
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., January 2026
!==============================================================================
program fasta

  integer, parameter   :: maxlineLength=200             ! Assume no input line is longer than this.
                                                        ! Wikipedia article on FASTA: typically no more than 80
  character (len=maxlineLength) :: inLine               ! Line to read
  integer :: l                                          ! Length of read line
  logical :: first=.true.

  ! going to read from a text file named "fasta.txt", located in the current working directory.
  open(unit=10, file='fasta.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if

  !-- Start the main I/O loop.
  !-- For simplicity, handle only lines starting with ">" as these introduce new sequences.
  !-- Any other lines are simply written to output without interpretation or checks.
  !
  do                                                      ! Loop ends at ERROR or EOF
    read (10,'(A)', iostat=io_stat)   inLine              ! not Q format, so its ok for both intel and GNU
    l = len_trim (inLine)                                 ! use this instead of Q format
    if (io_stat < 0) exit                                 ! EOF: Normal end of this loop
    if (io_stat > 0) then
      print *, "Read error"                               ! ERROR: never seen this error condition
      exit
    end if
    if (inLine (1:1) .eq. '>') then                       ! New sequence begins here
      if (first) then       ! First sequence: DO not terminate previous output, there is none.
        first = .false.
        write (*,'(1x,A, ": ")', advance='no') inLine (:l) ! Without terminating previous line
      else                  ! Second or later: terminate previous output line
        write (*,'(/,1x,A, ": ")', advance='no')inLine (:l)
      endif
    else if (first) then
      ! It is required that the 1st character of the very first line is a '>', anything else
      ! would be an error here.
      print *, 'ERROR: 1st char is not >'
      stop
    else
      ! Within the sequence: Append to current line
      write (*,'(A)', advance='no')  inLine (:l)
    end if
  end do

  write (*,*)     ! Terminate last line
end program fasta
