!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sat May 18 22:19:19
!
!a=./F && make $a && $a < unixdict.txt
!f95 -Wall -ffree-form F.F -o F
!   ie   ei  cie  cei
!  490  230   24   13
!         [^c]ie plausible
!            cei implausible
! ([^c]ie)|(cei) implausible
!
!Compilation finished at Sat May 18 22:19:19

! test the plausibility of i before e except...
program cia
  implicit none
  character (len=256) :: s
  integer :: ie, ei, cie, cei
  integer :: ios
  data ie, ei, cie, cei/4*0/
  do while (.true.)
    read(5,*,iostat = ios)s
    if (0 .ne. ios) then
      exit
    endif
    call lower_case(s)
    cie = cie + occurrences(s, 'cie')
    cei = cei + occurrences(s, 'cei')
    ie = ie + occurrences(s, 'ie')
    ei = ei + occurrences(s, 'ei')
  enddo
  write(6,'(1x,4(a4,1x))') 'ie','ei','cie','cei'
  write(6,'(1x,4(i4,1x))') ie,ei,cie,cei ! 488 230 24 13
  write(6,'(1x,2(a,1x))') '        [^c]ie',plausibility(ie,ei)
  write(6,'(1x,2(a,1x))') '           cei',plausibility(cei,cie)
  write(6,'(1x,2(a,1x))') '([^c]ie)|(cei)',plausibility(ie+cei,ei+cie)

contains

  subroutine lower_case(s)
    character(len=*), intent(inout) :: s
    integer :: i
    do i=1, len_trim(s)
      s(i:i) = achar(ior(iachar(s(i:i)),32))
    enddo
  end subroutine lower_case

  integer function occurrences(a,b)
    character(len=*), intent(in) :: a, b
    integer :: i, j, n
    n = 0
    i = 0
    j = index(a, b)
    do while (0 .lt. j)
      n = n+1
      i = i+len(b)+j-1
      j = index(a(i:), b)
    end do
    occurrences = n
  end function occurrences

  character*(32) function plausibility(da, nyet)
    integer, intent(in) :: da, nyet
    !write(0,*)da,nyet
    if (nyet*2 .lt. da) then
      plausibility = 'plausible'
    else
      plausibility = 'implausible'
    endif
  end function plausibility
end program cia
