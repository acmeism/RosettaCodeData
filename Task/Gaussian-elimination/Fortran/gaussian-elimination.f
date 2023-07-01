        program ge

          real, allocatable :: a(:,:),b(:)
          a = reshape(                             &
          [1.0, 1.00, 1.00,  1.00,   1.00,   1.00, &
           0.0, 0.63, 1.26,  1.88,   2.51,   3.14, &
           0.0, 0.39, 1.58,  3.55,   6.32,   9.87, &
           0.0, 0.25, 1.98,  6.70,  15.88,  31.01, &
           0.0, 0.16, 2.49, 12.62,  39.90,  97.41, &
           0.0, 0.10, 3.13, 23.80, 100.28, 306.02], [6,6] )
          b = [-0.01, 0.61, 0.91, 0.99, 0.60, 0.02]
          print'(f15.7)',solve_wbs(ge_wpp(a,b))

        contains

          function solve_wbs(u) result(x) ! solve with backward substitution
            real                 :: u(:,:)
            integer              :: i,n
            real   , allocatable :: x(:)
            n = size(u,1)
            allocate(x(n))
            forall (i=n:1:-1) x(i) = ( u(i,n+1) - sum(u(i,i+1:n)*x(i+1:n)) ) / u(i,i)
          end function

          function  ge_wpp(a,b) result(u) ! gaussian eliminate with partial pivoting
            real                 :: a(:,:),b(:),upi
            integer              :: i,j,n,p
            real   , allocatable :: u(:,:)
            n = size(a,1)
            u = reshape( [a,b], [n,n+1] )
            do j=1,n
              p = maxloc(abs(u(j:n,j)),1) + j-1 ! maxloc returns indices between (1,n-j+1)
              if (p /= j) u([p,j],j) = u([j,p],j)
              u(j+1:,j) = u(j+1:,j)/u(j,j)
              do i=j+1,n+1
                upi = u(p,i)
                if (p /= j) u([p,j],i) = u([j,p],i)
                u(j+1:n,i) = u(j+1:n,i) - upi*u(j+1:n,j)
              end do
            end do
          end function

        end program
