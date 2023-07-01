      program feigenbaum
      implicit none

      integer i, j, k
      real ( KIND = 16 ) x, y, a, b, a1, a2, d1

      print '(a4,a13)', 'i', 'd'

      a1 = 1.0;
      a2 = 0.0;
      d1 = 3.2;

      do i=2,20
         a = a1 + (a1 - a2) / d1;
         do j=1,10
            x = 0
            y = 0
            do k=1,2**i
                y = 1 - 2 * y * x;
                x = a - x**2;
            end do
            a = a - x / y;
         end do

         d1 = (a1 - a2) / (a - a1);
         a2 = a1;
         a1 = a;
         print '(i4,f13.10)', i, d1
     end do
     end
