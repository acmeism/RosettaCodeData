program read_file
    implicit none
    integer :: n
    character(:), allocatable :: s

    open(unit=10, file="read_file.f90", action="read", &
         form="unformatted", access="stream")
    inquire(unit=10, size=n)
    allocate(character(n) :: s)
    read(10) s
    close(10)

    print "(A)", s
end program
