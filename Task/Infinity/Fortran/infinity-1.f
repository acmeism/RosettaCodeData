program to_f_the_ineffable
   use, intrinsic :: ieee_arithmetic
   integer :: i
   real dimension(2) :: y, x = (/ 30, ieee_value(y,ieee_positive_inf) /)

   do i = 1, 2
      if (ieee_support_datatype(x(i))) then
         if (ieee_is_finite(x(i))) then
            print *, 'x(',i,') is finite'
         else
            print *, 'x(',i,') is infinite'
         end if

      else
         print *, 'x(',i,') is not in an IEEE-supported format'
      end if
   end do
end program to_f_the_ineffable
