program main

 implicit none

 integer :: i
 character(len=5),dimension(5),parameter :: colors = ['Red  ','Green','Blue ','Black','White']

 !using a do loop:
 do i=1,size(colors)
   write(*,'(A)') colors(i)
 end do

 !this will also print each element:
 write(*,'(A)') colors

end program main
