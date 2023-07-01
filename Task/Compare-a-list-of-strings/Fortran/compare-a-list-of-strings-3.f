program    compare_char_list
   implicit none
   character(len=6), allocatable, dimension(:) :: ss
   integer :: many
   ss = ["Fee","Fie","Foe","Fum"]
   many = size(ss)
   if (all(ss(1:many - 1) .lt. ss(2:many))) then
      write (*,*) many," strings: strictly increasing in order."
   else
      write (*,*) many," strings: not strictly increasing in order."
   end if
   if (all(ss(1:many - 1) .eq. ss(2:many))) then
      write (*,*) many," strings: all equal."
   else
      write (*,*) many," strings: not all equal."
   end if
end program compare_char_list
