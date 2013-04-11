 program test
 implicit none

 integer :: i  !scalar integer
 integer,dimension(10) :: ivec !integer vector
 real :: r !scalar real
 real,dimension(10) :: rvec !real vector
 character(len=:),allocatable :: char1, char2  !fortran 2003 allocatable strings

!assignments:

!-- scalars:
 i = 1
 r = 3.14

!-- vectors:
 ivec = 1 !(all elements set to 1)
 ivec(1:5) = 2

 rvec(1:9) = 0.0
 rvec(10) = 1.0

!-- strings:
 char1 = 'hello world!'
 char2 = char1   !copy from one string to another
 char2(1:1) = 'H'  !change first character

end program test
