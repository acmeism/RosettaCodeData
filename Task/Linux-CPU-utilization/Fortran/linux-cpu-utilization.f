Program CPUusage
    implicit none
    integer :: ios, i
    integer :: oldidle, oldsum, sumtimes = 0
    real :: percent = 0.
    character(len = 4) lineID ! 'cpu '
    integer, dimension(9) :: times = 0

    write(*, *) 'CPU Usage'
    write(*, *) 'Press Ctrl<C> to end'
    do while (.true.)
        open(unit = 7, file = '/proc/stat', status = 'old', action = 'read', iostat = ios)
        if (ios /= 0) then
            print *, 'Error opening /proc/stat'
            stop
        else
            read(unit = 7, fmt = *, iostat = ios) lineID, (times(i), i = 1, 9)
            close(7)
            if (lineID /= 'cpu ') then
                print *, 'Error reading /proc/stat'
                stop
            end if
            sumtimes = sum(times)
            percent = (1. - real((times(4) - oldidle)) / real((sumtimes - oldsum))) * 100.
            write(*, fmt = '(F6.2,A2)') percent, '%'
            oldidle = times(4)
            oldsum = sumtimes
            call sleep(1)
        end if
    end do
end program CPUusage
