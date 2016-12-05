program FileIO

  integer, parameter :: out = 123, in = 124
  integer :: err
  character :: c

  open(out, file="output.txt", status="new", action="write", access="stream", iostat=err)
  if (err == 0) then
     open(in, file="input.txt", status="old", action="read", access="stream", iostat=err)
     if (err == 0) then
        err = 0
        do while (err == 0)
           read(unit=in, iostat=err) c
           if (err == 0) write(out) c
        end do
        close(in)
     end if
     close(out)
  end if

end program FileIO
