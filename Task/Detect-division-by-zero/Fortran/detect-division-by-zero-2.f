program    rosetta_integer_divbyzero
   implicit none
   integer :: normal,zero,answer
   normal = 1
   zero = 0
   answer = normal/ zero
   write(*,*) answer
end program rosetta_integer_divbyzero
