program BasicInputLoop

  implicit none

  integer, parameter        :: in = 50, &
                               linelen = 1000
  integer                   :: ecode
  character(len=linelen)    :: l

  open(in, file="afile.txt", action="read", status="old", iostat=ecode)
  if ( ecode == 0 ) then
     do
        read(in, fmt="(A)", iostat=ecode) l
        if ( ecode /= 0 ) exit
        write(*,*) trim(l)
     end do
     close(in)
  end if

end program BasicInputLoop
