program longyear
    use iso_fortran_env, only: output_unit, input_unit
    implicit none

    integer             :: start, ende, i, counter
    integer, parameter  :: line_break=10

    write(output_unit,*) "Enter beginning of interval"
    read(input_unit,*) start
    write(output_unit,*) "Enter end of interval"
    read(input_unit,*) ende

    if (start>=ende) error stop "Last year must be after first year!"

    counter = 0
    do i = start, ende
        if (is_long_year(i)) then
            write(output_unit,'(I0,x)', advance="no") i
            counter = counter + 1
            if (modulo(counter,line_break) == 0) write(output_unit,*)
        end if
    end do
contains
    pure function p(year)
        integer, intent(in) :: year
        integer             :: p

        p = modulo(year + year/4 - year/100 + year/400, 7)
    end function p

    pure function is_long_year(year)
        integer, intent(in) :: year
        logical             :: is_long_year

        is_long_year = p(year) == 4 .or. p(year-1) == 3
    end function is_long_year
end program longyear
