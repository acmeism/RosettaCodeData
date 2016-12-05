        program mc
        integer :: n,i
        real(8) :: pi
        n=10000
        do i=1,5
          print*,n,pi(n)
          n = n * 10
        end do
        end program

        function  pi(n)
        integer :: n
        real(8) :: x(2,n),pi
        call random_number(x)
        pi = 4.d0 * dble( count( hypot(x(1,:),x(2,:)) <= 1.d0 ) ) / n
        end function
