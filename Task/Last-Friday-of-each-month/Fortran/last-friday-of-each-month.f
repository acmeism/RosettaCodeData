program fridays
   implicit none
   integer :: days(1:12) = (/31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31/)
   integer :: year, k, y, m
   read *, year
   if (mod(year, 400) == 0 .or. (mod(year, 4) == 0 .and. mod(year, 100) /= 0)) days(2) = 29
   y = year - 1
   k = 44 + y + y/4 + 6*(y/100) + y/400
   do m = 1, 12
      k = k + days(m)
      print "(I4,A1,I2.2,A1,I2)", year, '-', m, '-', days(m) - mod(k, 7)
   end do
end program
