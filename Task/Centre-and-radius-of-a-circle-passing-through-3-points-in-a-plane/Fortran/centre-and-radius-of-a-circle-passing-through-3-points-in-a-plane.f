program circle_demo
   use iso_fortran_env, only: real64
   implicit none
   real(kind=real64) :: x1, y1, x2, y2, x3, y3
   real(kind=real64) :: xc, yc, r

   ! Points
   x1 = 22.83d0
   y1 = 2.07d0
   x2 = 14.39d0
   y2 = 30.24d0
   x3 = 33.65d0
   y3 = 17.31d0

   call circle_from_three_points(x1, y1, x2, y2, x3, y3, xc, yc, r)

   print *, "Circle center: (", xc, ",", yc, ")"
   print *, "Circle radius: ", r

contains

   subroutine circle_from_three_points(x1, y1, x2, y2, x3, y3, xc, yc, r)
      implicit none
      real(kind=real64), intent(in) :: x1, y1, x2, y2, x3, y3
      real(kind=real64), intent(out) :: xc, yc, r
      real(kind=real64) :: a11, a12, a13
      real(kind=real64) :: a21, a22, a23
      real(kind=real64) :: a31, a32, a33
      real(kind=real64) :: d

      ! Determinant method
      a11 = x1
      a12 = y1
      a13 = 1.0d0
      a21 = x2
      a22 = y2
      a23 = 1.0d0
      a31 = x3
      a32 = y3
      a33 = 1.0d0

      d = 2.0d0 * (a11 * (a22 * a33 - a23 * a32) - a12 * (a21 * a33 - a23 * a31) + a13 * (a21 * a32 - a22 * a31))

      if (abs(d) < 1.0d-12) then
         print *, "Points are collinear or nearly collinear"
         stop
      end if

      ! From Wikipedia: https://en.wikipedia.org/wiki/Circumscribed_circle#Cartesian_coordinates
      xc = ((x1**2 + y1**2) * (y2 - y3) + (x2**2 + y2**2) * (y3 - y1) + (x3**2 + y3**2) * (y1 - y2)) / d
      yc = ((x1**2 + y1**2) * (x3 - x2) + (x2**2 + y2**2) * (x1 - x3) + (x3**2 + y3**2) * (x2 - x1)) / d

      ! Radius
      r = sqrt((xc - x1)**2 + (yc - y1)**2)

   end subroutine circle_from_three_points

end program circle_demo

