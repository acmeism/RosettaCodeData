!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Fri Jun  6 15:40:18
!
!a=./f && make -k $a && echo 0 25 | $a && echo 250 265 | $a && echo 1000 1025 | $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none -g f.f08 -o f
!                  0'th                  1'st                  2'nd
!                  3'rd                  4'th                  5'th
!                  6'th                  7'th                  8'th
!                  9'th                 10'th                 11'th
!                 12'th                 13'th                 14'th
!                 15'th                 16'th                 17'th
!                 18'th                 19'th                 20'th
!                 21'st                 22'nd                 23'rd
!                 24'th                 25'th
!                                      250'th                251'st
!                252'nd                253'rd                254'th
!                255'th                256'th                257'th
!                258'th                259'th                260'th
!                261'st                262'nd                263'rd
!                264'th                265'th
!                                     1000th                1001st
!               1002nd                1003rd                1004th
!               1005th                1006th                1007th
!               1008th                1009th                1010th
!               1011th                1012th                1013th
!               1014th                1015th                1016th
!               1017th                1018th                1019th
!               1020th                1021st                1022nd
!               1023rd                1024th                1025th
!
!Compilation finished at Fri Jun  6 15:40:18

program nth
  implicit none
  logical :: need
  integer :: here, there, n, i, iostat
  read(5,*,iostat=iostat) here, there
  if (iostat .ne. 0) then
     write(6,*)'such bad input never before seen.'
     write(6,*)'I AYE EYE QUIT!'
     call exit(1)
  end if
  need = .false.
  n = abs(there - here) + 1
  i = 0
  do while (0 /= mod(3+mod(here-i, 3), 3))
     write(6,'(a22)',advance='no') ''
     i = i+1
  end do
  do i = here, there, sign(1, there-here)
     write(6,'(a22)',advance='no') ordinate(i)
     if (2 /= mod(i,3)) then
        need = .true.
     else
        write(6,'(a)')''
        need = .false.
     end if
  end do
  if (need) write(6,'(a)')''

contains

  character(len=22) function ordinate(n)
    character(len=19) :: a
    character(len=20), parameter :: &
         &a09 =   "thstndrdthththththth",&
         &ateen = "thththththththththth"
    integer :: ones, tens, ones_index
    integer, intent(in) :: n
    write(a,'(i19)') n
    ones = mod(n,10)
    tens = mod(n,100)
    ones_index = ones*2+1
    if (n < 1000) then
       if ((10 .le. tens) .and. (tens .lt. 20)) then
          ordinate = a // "'" // ateen(ones_index:ones_index+1)
       else
          ordinate = a // "'" // a09(ones_index:ones_index+1)
       end if
    else
       if ((10 .le. tens) .and. (tens .lt. 20)) then
          ordinate = a // ateen(ones_index:ones_index+1)
       else
          ordinate = a // a09(ones_index:ones_index+1)
       end if
    end if
  end function ordinate

end program nth
