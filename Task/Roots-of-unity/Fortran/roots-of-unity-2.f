program unity
     real, parameter :: pi = 3.141592653589793
     complex, parameter :: i = (0, 1)
     complex, dimension(0:7-1) :: unit_circle
     integer :: n, j

     do n = 2, 7
          !!!! KEY STEP, does all the calculations in one statement !!!!
        unit_circle(0:n-1) = exp(2*i*pi/n * (/ (j, j=0, n-1) /) )

        write(*,"(i1,a)", advance="no") n, ": "
        write(*,"(sp,2f7.4,a)", advance="no") (unit_circle(j), "j  ", j = 0, n-1)
        write(*,*)
     end do
 end program unity
