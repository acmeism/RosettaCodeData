program main
 implicit none

 integer,parameter :: n_vals = 3
 character(len=*),dimension(n_vals),parameter :: ls = ['a','b','c']
 character(len=*),dimension(n_vals),parameter :: us = ['A','B','C']
 integer,dimension(n_vals),parameter          :: ns = [1,2,3]

 integer :: i  !counter

 do i=1,n_vals
      write(*,'(A1,A1,I1)') ls(i),us(i),ns(i)
 end do

end program main
