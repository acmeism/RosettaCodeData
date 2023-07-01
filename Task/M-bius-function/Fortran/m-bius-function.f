program moebius
    use iso_fortran_env, only: output_unit

    integer, parameter          :: mu_max=1000000, line_break=20
    integer, parameter          :: sqroot=int(sqrt(real(mu_max)))
    integer                     :: i, j
    integer, dimension(mu_max)  :: mu

    mu = 1

    do i = 2, sqroot
        if (mu(i) == 1) then
            do j = i, mu_max, i
                mu(j) = mu(j) * (-i)
            end do

            do j = i**2, mu_max, i**2
                mu(j) = 0
            end do
        end if
    end do

    do i = 2, mu_max
        if (mu(i) == i) then
            mu(i) = 1
        else if (mu(i) == -i) then
            mu(i) = -1
        else if (mu(i) < 0) then
            mu(i) = 1
        else if (mu(i) > 0) then
            mu(i) = -1
        end if
    end do

    write(output_unit,*) "The first 199 terms of the Möbius sequence are:"
    write(output_unit,'(3x)', advance="no") ! Alignment of first number
    do i = 1, 199
        write(output_unit,'(I2,x)', advance="no") mu(i)
        if (modulo(i+1, line_break) == 0) write(output_unit,*)
    end do
end program moebius
