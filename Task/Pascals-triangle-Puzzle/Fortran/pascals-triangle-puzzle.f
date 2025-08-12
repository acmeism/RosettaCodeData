!
module solve_pyramid_gauss
   implicit none
contains
   subroutine gauss
      implicit none
      integer, parameter :: n = 3
      real(kind=8) :: a(n, n), b(n), x(n)
      integer :: i, j, k
      real(kind=8) :: factor, tmp_row(n), tmp_b

      ! Build the 3×3 system
      a = 0.0d0
      b = 0.0d0

      ! Eq1:  X +   Y       = 18
      a(1, 1) = 1
      a(1, 2) = 1
      b(1) = 18

      ! Eq2:  X + 6Y +  Z   = 91
      a(2, 1) = 1
      a(2, 2) = 6
      a(2, 3) = 1
      b(2) = 91

      ! Eq3: -X +  Y -  Z   =  0
      a(3, 1) = -1
      a(3, 2) = 1
      a(3, 3) = -1
      b(3) = 0

      ! Gaussian elimination with manual pivot swap
      do k = 1, n - 1
         ! if pivot is near zero, swap with next row
         if (abs(a(k, k)) < 1e-12) then
            tmp_row = a(k, :)
            a(k, :) = a(k + 1, :)
            a(k + 1, :) = tmp_row
            tmp_b = b(k)
            b(k) = b(k + 1)
            b(k + 1) = tmp_b
         end if

         ! eliminate below
         do i = k + 1, n
            factor = a(i, k) / a(k, k)
            do j = k, n
               a(i, j) = a(i, j) - factor * a(k, j)
            end do
            b(i) = b(i) - factor * b(k)
         end do
      end do

      ! back substitution
      x(n) = b(n) / a(n, n)
      do i = n - 1, 1, -1
         factor = 0.0d0
         do j = i + 1, n
            factor = factor + a(i, j) * x(j)
         end do
         x(i) = (b(i) - factor) / a(i, i)
      end do

      print "(/,1X,A)", "Gaussian Solution:"
      print "(2(A,1x,I0,3x),a,1x,i0)", "  X =", int(x(1)), "  Y =", int(x(2)), "  Z =", int(x(3))

   end subroutine gauss

end module solve_pyramid_gauss
program solve_pyramid
   use solve_pyramid_gauss
   implicit none

   integer, parameter :: maxval = 100
   integer :: x, y, z
   integer :: a(5), b(4), c(3), d(2), e

   ! Brute-force X and Z in [0, MAXVAL]
   do x = 0, maxval
      do z = 0, maxval
         y = x + z

         ! Base row: [ X, 11, Y, 4, Z ]
         a = (/ x, 11, y, 4, z /)

         ! Build level 4
         b(1) = a(1) + a(2)
         b(2) = a(2) + a(3)
         b(3) = a(3) + a(4)
         b(4) = a(4) + a(5)

         ! Build level 3
         c(1) = b(1) + b(2)
         c(2) = b(2) + b(3)
         c(3) = b(3) + b(4)

         ! Check the known middle-upper constraint
         if (c(1) == 40) then

            ! Build level 2 and apex
            d(1) = c(1) + c(2)
            d(2) = c(2) + c(3)
            e = d(1) + d(2)

            ! Check the apex constraint
            if (e == 151) then
               print *, "Solution found:"
               print "(2(A,1x,I0,3x),a,1x,i0)", "  X =", x, "  Y =", y, "  Z =", z
               print *, "  Pyramid:"
               print *, "    Top:       [", e, "]"
               print *, "    Level 2:   [", d(1), " ", d(2), "]"
               print *, "    Level 3:   [", c(1), " ", c(2), " ", c(3), "]"
               print *, "    Level 4:   [", b(1), " ", b(2), " ", b(3), " ", b(4), "]"
               print *, "    Base row:  [", a(1), " ", a(2), " ", a(3), " ", &
                     a(4), " ", a(5), "]"
            end if

         end if

      end do
   end do
   call gauss
end program solve_pyramid
