!Digital Text implemented as in C version - Anant Dixit (Oct, 2014)
program clock
implicit none
integer :: t(8)
do
  call date_and_time(values=t)
  call sleep(1)
  call system('clear')
  call digital_display(t(5),t(6),t(7))
end do
end program

subroutine digital_display(H,M,S)
!arguments
integer :: H, M, S
!local
character(len=*), parameter :: nfmt='(A8)', cfmt='(A6)'
character(len=88), parameter :: d1 = ' 00000     1     22222   33333      4   5555555  66666  7777777  88888   99999        '
character(len=88), parameter :: d2 = '0     0   11    2     2 3     3    44   5       6     6 7     7 8     8 9     9  ::   '
character(len=88), parameter :: d3 = '0    00  1 1          2       3   4 4   5       6             7 8     8 9     9  ::   '
character(len=88), parameter :: d4 = '0   0 0    1         2        3  4  4   5       6            7  8     8 9     9  ::   '
character(len=88), parameter :: d5 = '0  0  0    1        2      333  4444444 555555  666666      7    88888   999999       '
character(len=88), parameter :: d6 = '0 0   0    1       2          3     4         5 6     6    7    8     8       9  ::   '
character(len=88), parameter :: d7 = '00    0    1      2           3     4         5 6     6   7     8     8       9  ::   '
character(len=88), parameter :: d8 = '0     0    1     2      3     3     4   5     5 6     6  7      8     8 9     9  ::   '
character(len=88), parameter :: d9 = ' 00000  1111111 2222222  33333      4    55555   66666  7        88888   99999        '
integer :: h1, h2, m1, m2, s1, s2
h1 = 1+8*floor(dble(H)/10.D0)
h2 = 1+8*modulo(H,10)
m1 = 1+8*floor(dble(M)/10.D0)
m2 = 1+8*modulo(M,10)
s1 = 1+8*floor(dble(S)/10.D0)
s2 = 1+8*modulo(S,10)

write(*,nfmt,advance='no') d1(h1:h1+8)
write(*,nfmt,advance='no') d1(h2:h2+8)
write(*,cfmt,advance='no') d1(81:88)
write(*,nfmt,advance='no') d1(m1:m1+8)
write(*,nfmt,advance='no') d1(m2:m2+8)
write(*,cfmt,advance='no') d1(81:88)
write(*,nfmt,advance='no') d1(s1:s1+8)
write(*,nfmt) d1(s2:s2+8)

write(*,nfmt,advance='no') d2(h1:h1+8)
write(*,nfmt,advance='no') d2(h2:h2+8)
write(*,cfmt,advance='no') d2(81:88)
write(*,nfmt,advance='no') d2(m1:m1+8)
write(*,nfmt,advance='no') d2(m2:m2+8)
write(*,cfmt,advance='no') d2(81:88)
write(*,nfmt,advance='no') d2(s1:s1+8)
write(*,nfmt) d2(s2:s2+8)

write(*,nfmt,advance='no') d3(h1:h1+8)
write(*,nfmt,advance='no') d3(h2:h2+8)
write(*,cfmt,advance='no') d3(81:88)
write(*,nfmt,advance='no') d3(m1:m1+8)
write(*,nfmt,advance='no') d3(m2:m2+8)
write(*,cfmt,advance='no') d3(81:88)
write(*,nfmt,advance='no') d3(s1:s1+8)
write(*,nfmt) d3(s2:s2+8)

write(*,nfmt,advance='no') d4(h1:h1+8)
write(*,nfmt,advance='no') d4(h2:h2+8)
write(*,cfmt,advance='no') d4(81:88)
write(*,nfmt,advance='no') d4(m1:m1+8)
write(*,nfmt,advance='no') d4(m2:m2+8)
write(*,cfmt,advance='no') d4(81:88)
write(*,nfmt,advance='no') d4(s1:s1+8)
write(*,nfmt) d4(s2:s2+8)

write(*,nfmt,advance='no') d5(h1:h1+8)
write(*,nfmt,advance='no') d5(h2:h2+8)
write(*,cfmt,advance='no') d5(81:88)
write(*,nfmt,advance='no') d5(m1:m1+8)
write(*,nfmt,advance='no') d5(m2:m2+8)
write(*,cfmt,advance='no') d5(81:88)
write(*,nfmt,advance='no') d5(s1:s1+8)
write(*,nfmt) d5(s2:s2+8)

write(*,nfmt,advance='no') d6(h1:h1+8)
write(*,nfmt,advance='no') d6(h2:h2+8)
write(*,cfmt,advance='no') d6(81:88)
write(*,nfmt,advance='no') d6(m1:m1+8)
write(*,nfmt,advance='no') d6(m2:m2+8)
write(*,cfmt,advance='no') d6(81:88)
write(*,nfmt,advance='no') d6(s1:s1+8)
write(*,nfmt) d6(s2:s2+8)

write(*,nfmt,advance='no') d7(h1:h1+8)
write(*,nfmt,advance='no') d7(h2:h2+8)
write(*,cfmt,advance='no') d7(81:88)
write(*,nfmt,advance='no') d7(m1:m1+8)
write(*,nfmt,advance='no') d7(m2:m2+8)
write(*,cfmt,advance='no') d7(81:88)
write(*,nfmt,advance='no') d7(s1:s1+8)
write(*,nfmt) d7(s2:s2+8)

write(*,nfmt,advance='no') d8(h1:h1+8)
write(*,nfmt,advance='no') d8(h2:h2+8)
write(*,cfmt,advance='no') d8(81:88)
write(*,nfmt,advance='no') d8(m1:m1+8)
write(*,nfmt,advance='no') d8(m2:m2+8)
write(*,cfmt,advance='no') d8(81:88)
write(*,nfmt,advance='no') d8(s1:s1+8)
write(*,nfmt) d8(s2:s2+8)

write(*,nfmt,advance='no') d9(h1:h1+8)
write(*,nfmt,advance='no') d9(h2:h2+8)
write(*,cfmt,advance='no') d9(81:88)
write(*,nfmt,advance='no') d9(m1:m1+8)
write(*,nfmt,advance='no') d9(m2:m2+8)
write(*,cfmt,advance='no') d9(81:88)
write(*,nfmt,advance='no') d9(s1:s1+8)
write(*,nfmt) d9(s2:s2+8)

end subroutine
