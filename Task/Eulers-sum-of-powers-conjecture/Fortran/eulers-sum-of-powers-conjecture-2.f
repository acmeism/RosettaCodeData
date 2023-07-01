program sum_of_powers
  implicit none

  integer, parameter :: maxn = 249
  integer, parameter :: dprec = selected_real_kind(15)
  integer :: i, x0, x1, x2, x3, y
  real(dprec) :: n(maxn), sumx

  n = (/ (real(i, dprec)**5, i = 1, maxn) /)

outer: do x0 = 1, maxn
         do x1 = 1, maxn
           do x2 = 1, maxn
             do x3 = 1, maxn
               sumx = n(x0)+ n(x1)+ n(x2)+ n(x3)
               y = 1
               do while(y <= maxn .and. n(y) <= sumx)
                 if(n(y) == sumx) then
                   write(*,*) x0, x1, x2, x3, y
                   exit outer
                 end if
                 y = y + 1
               end do
             end do
           end do
         end do
       end do outer

end program
