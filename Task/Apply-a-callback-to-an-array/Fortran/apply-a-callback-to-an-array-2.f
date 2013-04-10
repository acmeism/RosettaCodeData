program testAC
    use arrCallback
    implicit none
    integer :: i, j
    real, dimension(3,4) :: b, &
        a = reshape( (/ ((10 * i + j, i = 1, 3), j = 1, 4) /), (/ 3,4 /) )

    do i = 1, 3
        write(*,*) a(i,:)
    end do

    b = cube( a )  ! Applies CUBE to every member of a,
                   ! and stores each result in the equivalent element of b
    do i = 1, 3
        write(*,*) b(i,:)
    end do
end program testAC
