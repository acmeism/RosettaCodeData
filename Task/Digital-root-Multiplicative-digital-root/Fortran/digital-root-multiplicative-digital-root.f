!Implemented by Anant Dixit (Oct, 2014)
program mdr
implicit none
integer :: i, mdr, mp, n, j
character(len=*), parameter :: hfmt = '(A18)', nfmt = '(I6)'
character(len=*), parameter :: cfmt = '(A3)', rfmt = '(I3)', ffmt = '(I9)'

write(*,hfmt) 'Number   MDR   MP '
write(*,*) '------------------'

i = 123321
call root_pers(i,mdr,mp)
write(*,nfmt,advance='no') i
write(*,cfmt,advance='no') '   '
write(*,rfmt,advance='no') mdr
write(*,cfmt,advance='no') '   '
write(*,rfmt) mp

i = 3939
call root_pers(i,mdr,mp)
write(*,nfmt,advance='no') i
write(*,cfmt,advance='no') '   '
write(*,rfmt,advance='no') mdr
write(*,cfmt,advance='no') '   '
write(*,rfmt) mp

i = 8822
call root_pers(i,mdr,mp)
write(*,nfmt,advance='no') i
write(*,cfmt,advance='no') '   '
write(*,rfmt,advance='no') mdr
write(*,cfmt,advance='no') '   '
write(*,rfmt) mp

i = 39398
call root_pers(i,mdr,mp)
write(*,nfmt,advance='no') i
write(*,cfmt,advance='no') '   '
write(*,rfmt,advance='no') mdr
write(*,cfmt,advance='no') '   '
write(*,rfmt) mp

write(*,*)
write(*,*)
write(*,*) 'First five numbers with MDR in first column: '
write(*,*) '---------------------------------------------'

do i = 0,9
  n = 0
  j = 0
  write(*,rfmt,advance='no') i
  do
    call root_pers(j,mdr,mp)
    if(mdr.eq.i) then
      n = n+1
      if(n.eq.5) then
        write(*,ffmt) j
        exit
      else
        write(*,ffmt,advance='no') j
      end if
    end if
    j = j+1
  end do
end do

end program

subroutine root_pers(i,mdr,mp)
implicit none
integer :: N, s, a, i, mdr, mp
n = i
a = 0
if(n.lt.10) then
  mdr = n
  mp = 0
  return
end if
do while(n.ge.10)
  a = a + 1
  s = 1
  do while(n.gt.0)
    s = s * mod(n,10)
    n = int(real(n)/10.0D0)
  end do
  n = s
end do
mdr = s
mp = a
end subroutine
