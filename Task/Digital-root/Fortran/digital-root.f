program prec
implicit none
integer(kind=16) :: i
i = 627615
call root_pers(i)
i = 39390
call root_pers(i)
i = 588225
call root_pers(i)
i = 393900588225
call root_pers(i)
end program

subroutine root_pers(i)
implicit none
integer(kind=16) :: N, s, a, i
write(*,*) 'Number: ', i
n = i
a = 0
do while(n.ge.10)
  a = a + 1
  s = 0
  do while(n.gt.0)
    s = s + n-int(real(n,kind=8)/10.0D0,kind=8) * 10_8
    n = int(real(n,kind=16)/real(10,kind=8),kind=8)
  end do
  n = s
end do
write(*,*) 'digital root = ', s
write(*,*) 'additive persistance = ', a
end subroutine
