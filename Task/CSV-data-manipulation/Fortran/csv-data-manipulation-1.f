program rowsum
    implicit none
    character(:), allocatable :: line, name, a(:)
    character(20) :: fmt
    double precision, allocatable :: v(:)
    integer :: n, nrow, ncol, i

    call get_command_argument(1, length=n)
    allocate(character(n) :: name)
    call get_command_argument(1, name)
    open(unit=10, file=name, action="read", form="formatted", access="stream")
    deallocate(name)

    call get_command_argument(2, length=n)
    allocate(character(n) :: name)
    call get_command_argument(2, name)
    open(unit=11, file=name, action="write", form="formatted", access="stream")
    deallocate(name)

    nrow = 0
    ncol = 0
    do while (readline(10, line))
        nrow = nrow + 1

        call split(line, a)

        if (nrow == 1) then
            ncol = size(a)
            write(11, "(A)", advance="no") line
            write(11, "(A)") ",Sum"
            allocate(v(ncol + 1))
            write(fmt, "('(',G0,'(G0,:,''',A,'''))')") ncol + 1, ","
        else
            if (size(a) /= ncol) then
                print "(A,' ',G0)", "Invalid number of values on row", nrow
                stop
            end if

            do i = 1, ncol
                read(a(i), *) v(i)
            end do
            v(ncol + 1) = sum(v(1:ncol))
            write(11, fmt) v
        end if
    end do
    close(10)
    close(11)
contains
    function readline(unit, line)
        use iso_fortran_env
        logical :: readline
        integer :: unit, ios, n
        character(:), allocatable :: line
        character(10) :: buffer

        line = ""
        readline = .false.
        do
            read(unit, "(A)", advance="no", size=n, iostat=ios) buffer
            if (ios == iostat_end) return
            readline = .true.
            line = line // buffer(1:n)
            if (ios == iostat_eor) return
        end do
    end function

    subroutine split(line, array, separator)
        character(*) line
        character(:), allocatable :: array(:)
        character, optional :: separator
        character :: sep
        integer :: n, m, p, i, k

        if (present(separator)) then
            sep = separator
        else
            sep = ","
        end if

        n = len(line)
        m = 0
        p = 1
        k = 1
        do i = 1, n
            if (line(i:i) == sep) then
                p = p + 1
                m = max(m, i - k)
                k = i + 1
            end if
        end do
        m = max(m, n - k + 1)

        if (allocated(array)) deallocate(array)
        allocate(character(m) :: array(p))

        p = 1
        k = 1
        do i = 1, n
            if (line(i:i) == sep) then
                array(p) = line(k:i-1)
                p = p + 1
                k = i + 1
            end if
        end do
        array(p) = line(k:n)
    end subroutine
end program
