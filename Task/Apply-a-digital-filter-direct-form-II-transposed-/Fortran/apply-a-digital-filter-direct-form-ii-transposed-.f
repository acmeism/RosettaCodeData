module df2_filter
    implicit none
    real, parameter :: a(4) = [1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17]
    real, parameter :: b(4) = [0.16666667, 0.5, 0.5, 0.16666667]
    real :: w(4) = 0.0  ! State vector

contains
    function filter(x) result(y)
        real, intent(in) :: x
        real :: y
        integer :: i

        y = x * b(1) + w(1)

        do i = 2, 4
            w(i-1) = x * b(i) - y * a(i) + w(i)
        end do
    end function filter
end module df2_filter

program apply_filter
    use df2_filter
    implicit none
    real, dimension(20) :: input = [ &
        -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412, &
        -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044, &
        0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195, &
        0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293, &
        0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589 ]
    real, dimension(20) :: output
    integer :: i

    do i = 1, 20
        output(i) = filter(input(i))
    end do

    print *, "Filtered signal:"
    do i = 1,20
        write(*, '(f12.9,2x)',advance='no') output(i)
        if(mod(i,5)==0)write(*,*)
    end do
end program apply_filter
